-- GitHub Copilot Chat
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim

local augroup = vim.api.nvim_create_augroup("ruicsh/plugin/copilot-chat", { clear = true })

local CHAT_HISTORY_DIR = vim.fn.stdpath("data") .. "/copilot-chats"

-- Ordering matters, so that the most specific filetype configs are checked first
local FILETYPE_CONFIGS = {
	angular = {
		patterns = {
			"%.component%.ts$",
			"%.component%.html$",
			"%.module%.ts$",
			"%.directive%.ts$",
			"%.pipe%.ts$",
			"%.service%.ts$",
			"%.guard%.ts$",
			"%.resolver%.ts$",
			"%.injectable%.ts$",
		},
		filetypes = { "htmlangular" },
		priority = 1000,
		prompts = { "angular" },
	},
	ansible = {
		filetypes = { "yaml" },
		prompts = { "ansible" },
	},
	css = {
		filetypes = { "css", "scss", "less" },
		prompts = { "css" },
		patterns = {
			"%.css$",
			"%.scss$",
			"%.module%.css$",
		},
	},
	dockerfile = {
		filetypes = { "dockerfile" },
		prompts = { "docker" },
	},
	javascript = {
		filetypes = { "javascript" },
		prompts = { "js" },
	},
	neovim = {
		filetypes = { "vim", "lua" },
		prompts = { "neovim", "lua" },
		context = { "url:https://github.com/ruicsh/nvim-config" },
	},
	playwright = {
		prompts = { "playwright" },
		patterns = {
			"%.spec%.ts$",
		},
		priority = 5000,
	},
	python = {
		filetypes = { "python" },
		prompts = { "python" },
	},
	rust = {
		filetypes = { "rust" },
		prompts = { "rust" },
	},
	-- React specific configure ations
	storybook = {
		patterns = { "%.stories%.tsx$" },
		prompts = { "storybook" },
		priority = 5000,
		context = function()
			-- Return a context with the source file path
			local current_file = vim.fn.expand("%:p")
			local source_file = current_file:gsub("%.stories%.tsx$", ".tsx")
			if vim.fn.filereadable(source_file) == 1 then
				return { "file:" .. source_file }
			end

			return {}
		end,
	},
	reacttest = {
		patterns = { "%.test%.tsx$" },
		prompts = { "reacttest" },
		priority = 4000,
		context = function()
			-- Return a context with the source file path
			local current_file = vim.fn.expand("%:p")
			local source_file = current_file:gsub("%.test%.tsx$", ".tsx")
			if vim.fn.filereadable(source_file) == 1 then
				-- Convert to path relative to cwd
				local cwd = vim.fn.getcwd()
				local relative_path = source_file:gsub("^" .. vim.pesc(cwd) .. "/", "")
				return { "file:" .. relative_path }
			end

			return {}
		end,
	},
	typescripttest = {
		patterns = { "%.test%.ts$" },
		prompts = { "tstest" },
		priority = 3000,
		context = function()
			-- Return a context with the source file path
			local current_file = vim.fn.expand("%:p")
			local source_file = current_file:gsub("%.test%.ts$", ".ts")
			if vim.fn.filereadable(source_file) == 1 then
				return { "file:" .. source_file }
			end

			return {}
		end,
	},
	react = {
		filetypes = { "typescriptreact" },
		priority = 2000,
		prompts = { "react" },
	},
	typescript = {
		filetypes = { "typescript" },
		prompts = { "ts" },
	},
}

local function read_prompt_file(basename)
	local config_dir = tostring(vim.fn.stdpath("config"))
	local prompt_dir = vim.fs.joinpath(config_dir, "prompts")
	local file_path = vim.fs.joinpath(prompt_dir, string.format("%s.md", string.lower(basename)))
	if not vim.fn.filereadable(file_path) then
		return ""
	end

	return table.concat(vim.fn.readfile(file_path), "\n")
end

local function load_prompts(prompt_dir)
	local prompts = {}
	local prompt_files = vim.fn.glob(prompt_dir .. "/*.md", false, true)

	for _, file_path in ipairs(prompt_files) do
		local basename = vim.fn.fnamemodify(file_path, ":t:r")
		local prompt = read_prompt_file(basename)
		prompts[basename] = {
			prompt = prompt,
			system_prompt = prompt,
		}
	end

	return prompts
end

local function get_config_by_filetype()
	local ft = vim.bo.filetype
	local filename = vim.fn.expand("%:t")

	-- Sort FILETYPE_CONFIGS by priority, descending
	local sorted_configs = {}
	for _, config in pairs(FILETYPE_CONFIGS) do
		table.insert(sorted_configs, config)
	end
	table.sort(sorted_configs, function(a, b)
		local a_priority = a.priority or 0
		local b_priority = b.priority or 0
		return a_priority > b_priority
	end)

	for _, config in pairs(sorted_configs) do
		local matches = false

		-- Check file patterns if defined
		if config.patterns then
			for _, pattern in ipairs(config.patterns) do
				if filename:match(pattern) then
					matches = true
					break
				end
			end
		end

		-- Check filetypes
		if not matches and config.filetypes and vim.tbl_contains(config.filetypes, ft) then
			matches = true
		end

		if matches then
			if config.context and type(config.context) == "function" then
				config.context = config.context()
			end

			return config
		end
	end
end

local function get_system_prompt(action)
	local base_prompt = (action == "explain") and "COPILOT_EXPLAIN"
		or (action == "generic" and "COPILOT_INSTRUCTIONS")
		or "COPILOT_GENERATE"

	return base_prompt
end

local function get_prompts()
	-- Get filetype-specific prompts
	local ft_config = get_config_by_filetype()
	local prompts = ft_config and ft_config.prompts or {}

	return prompts
end

local function save_chat(response)
	local chat = require("CopilotChat")

	if vim.g.copilot_chat_title then
		chat.save(vim.g.copilot_chat_title)
		return
	end

	-- Use AI to generate prompt title based on first AI response to user question
	local prompt = read_prompt_file("chattitle")
	chat.ask(vim.trim(prompt:format(response)), {
		callback = function(gen_response)
			-- Generate timestamp in format YYYYMMDD_HHMMSS
			local timestamp = os.date("%Y%m%d_%H%M%S")
			-- Encode the generated title to make it safe as a filename
			local safe_title = vim.base64.encode(gen_response):gsub("/", "_"):gsub("+", "-"):gsub("=", "")
			vim.g.copilot_chat_title = timestamp .. "_" .. vim.trim(safe_title)
			chat.save(vim.g.copilot_chat_title)
			return gen_response
		end,
		headless = true, -- Disable updating chat buffer and history with this question
		model = vim.fn.getenv("COPILOT_MODEL_CHEAP"),
	})
end

local function new_chat_window(prompt, opts)
	local chat = require("CopilotChat")

	if opts.inline then
		opts.window = {
			layout = "float",
			relative = "cursor",
			width = 80,
			height = 20,
			row = -21,
			col = 3,
		}
	else
		opts.window = {
			layout = "vertical",
		}

		vim.ux.open_side_panel(false)
	end

	vim.g.copilot_chat_title = nil -- Reset chat title used for saving chat history
	chat.reset()

	if prompt ~= "" then
		chat.ask(prompt, opts)
	else
		chat.open(opts)
	end
end

local function customize_chat_window()
	vim.api.nvim_create_autocmd("BufEnter", {
		group = augroup,
		pattern = "copilot-*",
		callback = function()
			vim.opt_local.conceallevel = 0
			vim.opt_local.signcolumn = "yes:1"
		end,
	})
end

local function get_sticky_prompts()
	local sticky = {}

	-- Add filetype-specific prompts
	for _, p in pairs(get_prompts()) do
		table.insert(sticky, "/" .. p)
	end

	-- Always add diagnostics for current file
	table.insert(sticky, "#diagnostics:current")

	return sticky
end

local function open_chat(type, opts)
	local select = require("CopilotChat.select")

	return function()
		local model
		local selection
		local ft_config
		local sticky = {}

		if type == "assistance" then
			model = vim.fn.getenv("COPILOT_MODEL_CODEGEN")
			local is_visual_mode = vim.fn.mode():match("[vV]") ~= nil
			selection = is_visual_mode and select.visual or select.buffer
			ft_config = get_config_by_filetype()
			sticky = get_sticky_prompts()
		elseif type == "architect" then
			model = vim.fn.getenv("COPILOT_MODEL_ARCHITECT")
			selection = false
		elseif type == "search" then
			model = "perplexityai"
			selection = false
		end

		new_chat_window("", {
			context = ft_config and ft_config.context or {},
			inline = opts and opts.inline or false,
			model = model,
			selection = selection,
			system_prompt = get_system_prompt(type),
			sticky = sticky,
		})
	end
end

local function get_model_for_operation(operation_type)
	-- Define model environment variables in a central configuration
	local MODEL_ENV_VARS = {
		reason = "COPILOT_MODEL_REASON", -- Used for analysis operations
		architect = "COPILOT_MODEL_ARCHITECT", -- Used for high-level design
		codegen = "COPILOT_MODEL_CODEGEN", -- Default for code generation
	}

	-- Use a Set for faster lookups of analysis operations
	local ANALYSIS_OPERATIONS = {
		explain = true,
		review = true,
		-- Have refactor here to act as second opinion to codegen
		refactor = true,
	}

	-- Determine appropriate model type with fallbacks
	local env_var = MODEL_ENV_VARS.codegen -- Default to codegen model

	if ANALYSIS_OPERATIONS[operation_type] then
		env_var = MODEL_ENV_VARS.reason
	elseif operation_type == "architect" then
		env_var = MODEL_ENV_VARS.architect
	end

	-- Retrieve model with safety checks
	local selected_model = vim.fn.getenv(env_var)
	if not selected_model or selected_model == vim.NIL then
		vim.notify(
			string.format("Warning: Environment variable %s not set for operation '%s'", env_var, operation_type),
			vim.log.levels.WARN
		)
		return nil -- Could add default fallback here
	end

	return selected_model
end

local function get_visual_selection()
	-- Yank the visual selection
	vim.cmd('normal! "zy')
	local selection = vim.fn.getreg("z")
	-- Remove leading non-alphanumeric characters
	selection = vim.trim(selection:gsub("^[^a-zA-Z0-9]+", ""))

	return selection
end

local function action(type, opts)
	return function()
		local select = require("CopilotChat.select")

		local prompt = "Please"

		local sticky = get_sticky_prompts()
		table.insert(sticky, "/" .. type)

		local is_visual_mode = vim.fn.mode():match("[vV]") ~= nil
		local selection = nil

		if type == "generic" then
			selection = nil
		elseif type == "implement" then
			prompt = get_visual_selection() .. "\n\n"
			selection = select.buffer
		elseif is_visual_mode then
			selection = select.visual
		else
			selection = select.buffer
		end

		new_chat_window(prompt, {
			model = get_model_for_operation(type),
			selection = selection,
			system_prompt = get_system_prompt(type),
			sticky = sticky,
			inline = opts and opts.inline or false,
		})
	end
end

local function delete_old_chat_files()
	local scandir = require("plenary.scandir")

	local files = scandir.scan_dir(CHAT_HISTORY_DIR, {
		search_pattern = "%.json$",
		depth = 1,
	})

	local current_time = os.time()
	local one_month_ago = current_time - (30 * 24 * 60 * 60) -- 30 days in seconds
	local deleted_count = 0

	for _, file in ipairs(files) do
		local mtime = vim.fn.getftime(file)

		if mtime < one_month_ago then
			local success, err = os.remove(file)
			if success then
				deleted_count = deleted_count + 1
			else
				vim.notify("Failed to delete old chat file: " .. err, vim.log.levels.WARN)
			end
		end
	end

	if deleted_count > 0 then
		vim.notify("Deleted " .. deleted_count .. " old chat files", vim.log.levels.INFO)
	end
end

local function decode_title(encoded_title)
	-- Extract the timestamp part (before first underscore)
	local timestamp, encoded = encoded_title:match("^(%d%d%d%d%d%d%d%d_%d%d%d%d%d%d)_(.+)$")

	-- Restore base64 padding characters
	local padding_len = 4 - (#encoded % 4)
	if padding_len < 4 then
		encoded = encoded .. string.rep("=", padding_len)
	end

	-- Restore original base64 characters
	encoded = encoded:gsub("_", "/"):gsub("-", "+")

	-- Decode and return with timestamp if successful
	local success, decoded = pcall(vim.base64.decode, encoded)
	if success and timestamp then
		return timestamp .. ": " .. decoded
	else
		return encoded_title -- Fallback to encoded if decoding fails
	end
end

local function list_chat_history()
	local snacks = require("snacks")
	local chat = require("CopilotChat")
	local scandir = require("plenary.scandir")

	-- Delete old chat files first
	delete_old_chat_files()

	local files = scandir.scan_dir(CHAT_HISTORY_DIR, {
		search_pattern = "%.json$",
		depth = 1,
	})

	if #files == 0 then
		vim.notify("No chat history found", vim.log.levels.INFO)
		return
	end

	local items = {}
	for i, item in ipairs(files) do
		-- Extract basename from file's full path without extension
		local filename = item:match("^.+[/\\](.+)$") or item
		local basename = filename:match("^(.+)%.[^%.]*$") or filename

		table.insert(items, {
			idx = i,
			file = item,
			basename = basename,
			text = basename,
		})
	end

	table.sort(items, function(a, b)
		return a.file > b.file
	end)

	-- Check if we have any valid items
	if #items == 0 then
		vim.notify("No valid chat history files found", vim.log.levels.INFO)
		return
	end

	snacks.picker({
		actions = {
			delete_history_file = function(picker, item)
				if not item or not item.file then
					vim.notify("No file selected", vim.log.levels.WARN)
					return
				end

				-- Confirm deletion
				vim.ui.select(
					{ "Yes", "No" },
					{ prompt = "Delete " .. vim.fn.fnamemodify(item.file, ":t") .. "?" },
					function(choice)
						if choice == "Yes" then
							-- Delete the file
							local success, err = os.remove(item.file)
							if success then
								vim.notify("Deleted: " .. item.file, vim.log.levels.INFO)
								-- Refresh the picker to show updated list
								picker:close()
								vim.schedule(function()
									list_chat_history()
								end)
							else
								vim.notify("Failed to delete: " .. (err or "unknown error"), vim.log.levels.ERROR)
							end
						end
					end
				)
			end,
		},
		confirm = function(picker, item)
			picker:close()

			-- Verify file exists before loading
			if not vim.fn.filereadable(item.file) then
				vim.notify("Chat history file not found: " .. item.file, vim.log.levels.ERROR)
				return
			end

			vim.g.copilot_chat_title = item.basename
			vim.ux.open_side_panel(false)

			chat.open()
			chat.load(item.basename)
		end,
		items = items,
		format = function(item)
			local formatted_title = decode_title(item.basename)
			local display = " " .. formatted_title

			local mtime = vim.fn.getftime(item.file)
			local date = vim.fn.fmt_relative_time(mtime)

			return {
				{ string.format("%-5s", date), "SnacksPickerLabel" },
				{ display },
			}
		end,
		preview = function(ctx)
			local file = io.open(ctx.item.file, "r")
			if not file then
				ctx.preview:set_lines({ "Unable to read file" })
				return
			end

			local content = file:read("*a")
			file:close()

			local ok, messages = pcall(vim.json.decode, content, {
				luanil = {
					object = true,
					array = true,
				},
			})

			if not ok then
				ctx.preview:set_lines({ "vim.fn.json_decode error" })
				return
			end

			local config = chat.config
			local preview = {}
			for _, message in ipairs(messages or {}) do
				local header = message.role == "user" and config.question_header or config.answer_header
				table.insert(preview, header .. config.separator .. "\n")
				table.insert(preview, message.content .. "\n")
			end

			ctx.preview:highlight({ ft = "copilot-chat" })
			ctx.preview:set_lines(preview)
		end,
		sort = {
			fields = { "text:desc" },
		},
		title = "Copilot Chat History",
		win = {
			input = {
				keys = {
					["dd"] = "delete_history_file", -- Use our custom action
				},
			},
		},
	})
end

vim.api.nvim_create_user_command("CopilotCommitMessage", function()
	local chat = require("CopilotChat")
	local bufnr = vim.api.nvim_get_current_buf()

	-- Determine which prompt command to use based on work environment
	local is_work_env = vim.fn.getenv("IS_WORK") == "true"
	local prompt = "/" .. (is_work_env and "commitwork" or "commit")

	chat.reset() -- Reset previous chat state

	vim.fn.start_spinner(bufnr, "Generating commit message...")

	chat.ask(prompt, {
		callback = function(response)
			vim.fn.stop_spinner(bufnr)

			-- Convert response to table of lines and ensure it's always an array
			local lines = type(response) == "string" and vim.split(response, "\n")
				or (type(response) == "table" and response or {})
			table.insert(lines, "")

			-- Insert the response at cursor position
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

			-- Set cursor on the last line
			vim.cmd("normal! G")
			return response
		end,
		context = { "git_staged" },
		headless = true,
		model = vim.fn.getenv("COPILOT_MODEL_CHEAP"),
		system_prompt = "/COPILOT_INSTRUCTIONS",
	})
end, {})

vim.api.nvim_create_user_command("CopilotCodeReview", function()
	local chat = require("CopilotChat")

	chat.reset() -- Reset previous chat state

	chat.ask("/review", {
		callback = function(response)
			local function accept_code_review()
				vim.keymap.del("n", "<c-]>", { buffer = true })

				chat.close()

				vim.api.nvim_win_close(0, false)
				vim.cmd("vertical Git")
				vim.cmd("Git commit")
			end

			vim.keymap.set("n", "<c-]>", accept_code_review, { buffer = true })
			return response
		end,
		context = { "git_staged" },
		model = vim.fn.getenv("COPILOT_MODEL_REASON"),
		selection = false,
		system_prompt = "/COPILOT_REVIEW",
		window = {
			layout = "replace",
		},
	})
end, {})

vim.api.nvim_create_user_command("CopilotPrReview", function()
	local snacks = require("snacks")
	local branches = vim.git.list_remote_branches()

	local items = {}
	for i, branch in ipairs(branches) do
		table.insert(items, {
			idx = i,
			file = branch.name,
			text = branch.name,
			time = branch.time,
		})
	end

	snacks.picker({
		title = "Select a branch to review",
		items = items,
		layout = {
			preset = "vertical",
			hidden = { "preview" },
		},
		format = function(item)
			local time = vim.fn.fmt_relative_time(item.time)

			return {
				{ string.format("%-5s", time), "SnacksPickerLabel" },
				{ item.file },
			}
		end,
		confirm = function(picker, item)
			picker:close()

			vim.git.diff_branch(item.text, function(diff)
				local prompt = table.concat({
					"> /review",
					" ",
					"```gitcommit",
					table.concat(diff.commit_lines, "\n"),
					"```",
					" ",
					"```diff",
					table.concat(diff.diff_lines, "\n"),
					"```",
				}, "\n")

				vim.schedule(function()
					new_chat_window(prompt, {
						model = vim.fn.getenv("COPILOT_MODEL_REASON"),
						selection = false,
						system_prompt = "/COPILOT_INSTRUCTIONS",
					})
				end)
			end)
		end,
	})
end, {})

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	keys = function()
		local chat = require("CopilotChat")

		local mappings = {
			-- chat
			{ "<leader>aa", open_chat("assistance"), "Assistance", { mode = { "n", "v" } } },
			{ "<leader>ag", open_chat("generic"), "Assistance" },
			{ "<leader>as", open_chat("search"), "Search" },
			{ "<leader>aq", open_chat("architect"), "Architect" },

			-- inline chat
			{ "<leader>aA", open_chat("assistance", { inline = true }), "Assistance", { mode = { "n", "v" } } },
			{ "<leader>aG", open_chat("generic", { inline = true }), "Assistance" },
			{ "<leader>aS", open_chat("search", { inline = true }), "Search" },
			{ "<leader>aQ", open_chat("architect", { inline = true }), "Architect" },

			-- actions
			{ "<leader>ae", action("explain"), "Explain", { mode = { "n", "v" } } },
			{ "<leader>af", action("fix"), "Fix", { mode = { "n", "v" } } },
			{ "<leader>ai", action("implement"), "Implement", { mode = { "n", "v" } } },
			{ "<leader>ao", action("optimize"), "Optimize", { mode = { "n", "v" } } },
			{ "<leader>ar", action("review"), "Review", { mode = { "n", "v" } } },
			{ "<leader>at", action("tests"), "Tests", { mode = { "n", "v" } } },
			{ "<leader>an", action("refactor"), "Refactor", { mode = { "n", "v" } } },

			-- actions inline
			{ "<leader>aE", action("explain", { inline = true }), "Explain", { mode = "v" } },
			{ "<leader>aF", action("fix", { inline = true }), "Fix", { mode = { "v" } } },
			{ "<leader>aI", action("implement", { inline = true }), "Implement", { mode = "v" } },
			{ "<leader>aO", action("optimize", { inline = true }), "Optimize", { mode = "v" } },
			{ "<leader>aR", action("review", { inline = true }), "Review", { mode = { "v" } } },
			{ "<leader>aT", action("tests", { inline = true }), "Tests", { mode = "v" } },
			{ "<leader>aN", action("refactor", { inline = true }), "Refactor", { mode = "v" } },

			-- git
			{ "<leader>ap", ":CopilotPrReview<cr>", "PR review" },

			-- utilities
			{ "<leader>ah", list_chat_history, "List chat history" },
			{ "<leader>am", chat.select_model, "Models" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "AI")
	end,
	config = function()
		local chat = require("CopilotChat")
		local utils = require("CopilotChat.utils")
		local resources = require("CopilotChat.resources")

		vim.fn.load_env_file() -- Make sure the env file is loaded

		customize_chat_window()

		local proxy = vim.fn.env_get("COPILOT_PROXY")

		local prompts = load_prompts(vim.fn.stdpath("config") .. "/prompts")

		chat.setup({
			allow_insecure = true,
			auto_follow_cursor = true,
			auto_insert_mode = false,
			callback = function(response)
				save_chat(response)
			end,
			chat_autocomplete = false,
			-- debug = true,
			functions = {
				buffer = {
					group = "copilot",
					uri = "buffer://{name}",
					description = "Retrieves content from a specific buffer.",
					resolve = function(input)
						local bufnr = tonumber(input.bufnr)
						if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
							error("Invalid buffer number: " .. tostring(input.bufnr))
						end

						utils.schedule_main()
						local name = vim.api.nvim_buf_get_name(bufnr)
						local data, mimetype = resources.get_buffer(bufnr)

						return {
							{
								uri = "buffer://" .. name,
								name = name,
								mimetype = mimetype,
								data = data,
							},
						}
					end,
					schema = {
						type = "object",
						required = { "bufnr" },
						properties = {
							bufnr = {
								type = "number",
								description = "Buffer number to include in chat context.",
								enum = function()
									local chat_winid = vim.api.nvim_get_current_win()
									local async = require("plenary.async")
									local fn = async.wrap(function(callback)
										Snacks.picker.buffers({
											confirm = function(picker, item)
												picker:close()
												-- Return focus to the chat window
												if vim.api.nvim_win_is_valid(chat_winid) then
													vim.api.nvim_set_current_win(chat_winid)
													vim.cmd("normal! a")
												end
												callback({ item.buf })
											end,
										})
									end, 1)
									return fn()
								end,
							},
						},
					},
				},
				file = {
					group = "copilot",
					uri = "file://{path}",
					description = "Pick a file to include in chat context.",
					resolve = function(input)
						utils.schedule_main()
						local data, mimetype = resources.get_file(input.path)
						if not data then
							error("File not found: " .. input.path)
						end

						return {
							{
								uri = "file://" .. input.path,
								name = input.path,
								mimetype = mimetype,
								data = data,
							},
						}
					end,
					schema = {
						type = "object",
						required = { "path" },
						properties = {
							path = {
								type = "string",
								description = "Path to file to include in chat context.",
								enum = function()
									local chat_winid = vim.api.nvim_get_current_win()
									local async = require("plenary.async")
									local fn = async.wrap(function(callback)
										Snacks.picker.smart({
											confirm = function(picker, item)
												picker:close()
												-- Return focus to the chat window
												if vim.api.nvim_win_is_valid(chat_winid) then
													vim.api.nvim_set_current_win(chat_winid)
													vim.cmd("normal! a")
												end
												callback({ item.file })
											end,
										})
									end, 1)
									return fn()
								end,
							},
						},
					},
				},
				gitdiff = {
					group = "copilot",
					uri = "git://diff/{target}",
					description = "Retrieves git diff information. Requires git to be installed. Useful for discussing code changes or explaining the purpose of modifications.",
					schema = {
						type = "object",
						required = { "target" },
						properties = {
							target = {
								type = "string",
								description = "Target to diff against.",
								enum = { "unstaged", "staged", "<sha>" },
								default = "unstaged",
							},
						},
					},
					resolve = function(input, source)
						local cmd = { "git", "-C", source.cwd(), "diff", "--no-color", "--no-ext-diff" }

						if input.target == "staged" then
							table.insert(cmd, "--staged")
						elseif input.target == "unstaged" then
							table.insert(cmd, "--")
						else
							table.insert(cmd, input.target)
						end

						local EXCLUDE_FILES = { "package-lock.json", "lazy-lock.json", "Cargo.lock" }
						for _, file in ipairs(EXCLUDE_FILES) do
							table.insert(cmd, ":(exclude)" .. file)
						end

						local out = utils.system(cmd)

						return {
							{
								uri = "git://diff/" .. input.target,
								mimetype = "text/plain",
								data = out.stdout,
							},
						}
					end,
				},
			},
			insert_at_end = false,
			headers = {
				user = "꠵ User ",
				assistant = "꠵ Assistant ",
				tool = "꠵ Tool ",
			},
			history_path = CHAT_HISTORY_DIR, -- Default path to stored history
			log_level = "warn",
			mappings = {
				submit_prompt = {
					normal = "<c-s>",
					insert = "<c-s>",
				},
			},
			model = vim.fn.getenv("COPILOT_MODEL_CODEGEN"),
			prompts = prompts,
			proxy = proxy,
			remember_as_sticky = false,
			selection = false, -- Have no predefined context by default
			separator = " ",
			show_help = false,
			show_folds = true,
			window = {
				layout = "vertical",
				title = "",
			},
		})
	end,

	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
	},
}
