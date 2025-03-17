-- GitHub Copilot Chat
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim

local augroup = vim.api.nvim_create_augroup("ruicsh/plugin/copilot-chat", { clear = true })

local CHAT_HISTORY_DIR = vim.fn.stdpath("data") .. "/copilot-chats"

local FILETYPE_CONFIGS = {
	angular = {
		patterns = {
			"%.component%.ts$",
			"%.component%.html$",
			"%.module%.ts$",
		},
		filetypes = { "htmlangular" },
		prompts = { "angular", "js", "ts" },
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
	python = {
		filetypes = { "python" },
		prompts = { "python" },
	},
	typescript = {
		filetypes = { "typescript" },
		prompts = { "js", "ts" },
	},
	neovim = {
		filetypes = { "vim", "lua" },
		prompts = { "neovim", "lua" },
		contexts = { "url:https://github.com/ruicsh/nvim-config" },
	},
	rust = {
		filetypes = { "rust" },
		prompts = { "rust" },
	},
	react = {
		filetypes = { "typescriptreact" },
		prompts = { "react", "js", "ts" },
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
		-- Extract filename without extension
		local basename = vim.fn.fnamemodify(file_path, ":t:r")
		-- Use the read_prompt_file function to read the file
		prompts[basename] = read_prompt_file(basename)
	end

	return prompts
end

local function get_config_by_filetype()
	local ft = vim.bo.filetype
	local filename = vim.fn.expand("%:t")

	for _, config in pairs(FILETYPE_CONFIGS) do
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
		if config.filetypes and vim.tbl_contains(config.filetypes, ft) then
			matches = true
		end

		if matches then
			return config
		end
	end
end

local function concat_prompts(commands)
	return table.concat(
		vim.tbl_map(function(p)
			-- Add sticky commands
			return "\n> /" .. p
		end, commands),
		""
	)
end

local function get_system_prompts(action)
	local base_prompt = (action == "explain") and "COPILOT_EXPLAIN"
		or (action == "generic" and "COPILOT_INSTRUCTIONS")
		or "COPILOT_GENERATE"

	-- Get filetype-specific prompts
	local ft_config = get_config_by_filetype()
	local ft_prompts = ft_config and ft_config.prompts or {}

	-- Build list of prompts
	local prompts = { base_prompt }
	vim.list_extend(prompts, ft_prompts)

	return prompts
end

local function save_chat(response)
	local chat = require("CopilotChat")

	if vim.g.copilot_chat_title then
		chat.save(vim.g.copilot_chat_title)
		return
	end

	-- use AI to generate prompt title based on first AI response to user question
	local prompt = read_prompt_file("chattitle")
	chat.ask(vim.trim(prompt:format(response)), {
		headless = true, -- disable updating chat buffer and history with this question
		callback = function(gen_response)
			-- Generate timestamp in format YYYYMMDD_HHMMSS
			local timestamp = os.date("%Y%m%d_%H%M%S")
			vim.g.copilot_chat_title = timestamp .. "_" .. vim.trim(gen_response)
			chat.save(vim.g.copilot_chat_title)
		end,
	})
end

local function new_chat_window(prompt, opts)
	local chat = require("CopilotChat")

	vim.cmd("WindowToggleMaximize forceOpen") -- maximize the current window
	vim.cmd("vsplit") -- open a vertical split

	vim.g.copilot_chat_title = nil -- reset chat title used for saving chat history
	chat.reset()

	if prompt ~= "" then
		chat.ask(prompt, opts)
	else
		chat.open(opts)
	end
end

local function open_chat()
	local select = require("CopilotChat.select")

	local is_visual_mode = vim.fn.mode():match("[vV]") ~= nil

	local ft_config = get_config_by_filetype()
	local prompts = get_system_prompts("generic")
	local system_prompt = concat_prompts(prompts)

	new_chat_window("", {
		auto_insert_mode = true,
		contexts = ft_config and ft_config.contexts or {},
		-- if there's something selected use it, if not, use a blank context
		selection = is_visual_mode and select.visual or false,
		system_prompt = system_prompt,
	})
end

local function open_generic_chat()
	new_chat_window("", {
		auto_insert_mode = true,
		model = vim.fn.getenv("COPILOT_MODEL_GENERIC"),
		selection = false,
		system_prompt = concat_prompts({ "COPILOT_INSTRUCTIONS", "communication" }),
	})
end

local function open_search_chat()
	new_chat_window("", {
		agent = "perplexityai",
		auto_insert_mode = true,
		selection = false,
	})
end

local function operation(operation_type)
	return function()
		local select = require("CopilotChat.select")
		local prompts = get_system_prompts(operation_type)
		local system_prompt = concat_prompts(prompts)
		local prompt = "/" .. operation_type

		local opts = {
			auto_insert_mode = true,
			selection = select.visual,
			system_prompt = system_prompt,
		}

		new_chat_window(prompt, opts)
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
			vim.cmd("WindowToggleMaximize forceOpen")
			vim.cmd("vsplit")

			chat.open()
			chat.load(item.basename)
		end,
		items = items,
		format = function(item)
			local prompt = item.file:match("[0-9]*_[0-9]*_(.+)%.json$")
			local display = " " .. prompt:gsub("[-_]", " "):gsub("^%l", string.upper)

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
	local select = require("CopilotChat.select")
	local bufnr = vim.api.nvim_get_current_buf()

	-- yank everything in the buffer, to feed into the chat later
	vim.cmd("normal! ggVGy")

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
		end,
		headless = true,
		selection = select.unnamed,
		system_prompt = "/COPILOT_INSTRUCTIONS",
	})
end, {})

vim.api.nvim_create_user_command("CopilotCodeReview", function()
	local chat = require("CopilotChat")

	chat.reset() -- Reset previous chat state

	chat.ask("/codereview", {
		callback = function()
			local function accept_code_review()
				vim.keymap.del("n", "<c-y>", { buffer = true })

				chat.close()

				vim.cmd("WindowToggleMaximize forceOpen")
				vim.cmd("vertical Git")
				vim.cmd("Git commit")
			end

			vim.keymap.set("n", "<c-y>", accept_code_review, { buffer = true })
		end,
		selection = false,
		system_prompt = "/COPILOT_REVIEW",
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
					"```gitcommit",
					table.concat(diff.commit_lines, "\n"),
					"```",
					"```diff",
					table.concat(diff.diff_lines, "\n"),
					"```",
				}, "\n")

				vim.schedule(function()
					new_chat_window(prompt, {
						selection = false,
						system_prompt = concat_prompts({ "COPILOT_INSTRUCTIONS", "/prreview", "communication" }),
					})
				end)
			end)
		end,
	})
end, {})

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = "copilot-chat",
	callback = function()
		local ft = vim.bo.filetype
		if ft == "copilot-chat" then
			vim.opt_local.foldenable = false -- Never fold
			vim.opt_local.foldmethod = "manual" -- Disable folding
			vim.opt_local.foldlevel = 0 -- Don't fold anything
			vim.opt_local.foldcolumn = "0" -- Don't show fold column
			vim.opt_local.foldlevelstart = -1 -- Don't fold anything
			vim.opt_local.conceallevel = 0 -- Don't conceal markdown links
		end
	end,
})

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	keys = function()
		local chat = require("CopilotChat")

		local mappings = {
			-- chat
			{ "<leader>aa", open_chat, "Programming Chat", { mode = { "n", "v" } } },
			{ "<leader>ag", open_generic_chat, "Generic Chat" },
			{ "<leader>ah", list_chat_history, "List chat history" },
			{ "<leader>am", chat.select_model, "Models" },
			{ "<leader>as", open_search_chat, "Search Chat" },

			-- predefined prompts
			{ "<leader>ae", operation("explain"), "Explain", { mode = "v" } },
			{ "<leader>af", operation("fix"), "Fix", { mode = "v" } },
			{ "<leader>ai", operation("implement"), "Implement", { mode = "v" } },
			{ "<leader>ao", operation("optimize"), "Optimize", { mode = "v" } },
			{ "<leader>ar", operation("refactor"), "Refactor", { mode = "v" } },
			{ "<leader>at", operation("tests"), "Tests", { mode = "v" } },

			-- git
			{ "<leader>ap", ":CopilotPrReview<cr>", "PR review" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "AI")
	end,
	config = function()
		local chat = require("CopilotChat")
		local providers = require("CopilotChat.config.providers")
		local user = vim.env.USER or "User"

		vim.fn.load_env_file() -- make sure the env file is loaded

		local env_lmstudio = vim.fn.getenv("COPILOT_URL_LMSTUDIO")
		local lmstudio_base_url = env_lmstudio ~= vim.NIL and env_lmstudio or ""

		chat.setup({
			agent = "copilot",
			answer_header = " Copilot ",
			auto_follow_cursor = false, -- Don't follow cursor in chat buffer
			callback = function(response)
				save_chat(response)
			end,
			chat_autocomplete = false,
			error_header = "  Error ",
			insert_at_end = true,
			history_path = CHAT_HISTORY_DIR, -- Default path to stored history
			log_level = "warn",
			mappings = {
				accept_diff = {
					normal = "<c-y>",
					insert = "<c-y>",
				},
				close = {
					normal = "<c-]>",
					insert = "<c-]>",
				},
				reset = {
					normal = "<c-x>",
					insert = "<c-x>",
				},
			},
			model = vim.fn.getenv("COPILOT_MODEL_CODER"),
			prompts = load_prompts(vim.fn.stdpath("config") .. "/prompts"),
			providers = {
				lmstudio = {
					embed = "copilot_embeddings",
					prepare_input = providers.copilot.prepare_input,
					prepare_output = providers.copilot.prepare_output,
					get_headers = function()
						return {
							["Content-Type"] = "application/json",
						}
					end,
					get_models = function(headers)
						if lmstudio_base_url == "" then
							return {}
						end

						local utils = require("CopilotChat.utils")

						local response = utils.curl_get(lmstudio_base_url .. "/v1/models", { headers = headers })
						if not response or response.status ~= 200 then
							error("Failed to fetch models: " .. tostring(response and response.status))
						end

						local models = {}
						for _, model in ipairs(vim.json.decode(response.body)["data"]) do
							table.insert(models, {
								id = model.id,
								name = model.id,
							})
						end
						return models
					end,
					get_url = function()
						local base_url = vim.fn.getenv("COPILOT_URL_LMSTUDIO")
						return base_url .. "/v1/chat/completions"
					end,
				},
			},
			references_display = "write", -- Display references as md links
			question_header = " " .. user .. " ",
			selection = false, -- Have no predefined context by default
			show_help = false,
			window = {
				layout = "replace",
			},
		})
	end,

	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
	},
}
