-- GitHub Copilot Chat
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim

local icons = require("config.icons")

local CHAT_HISTORY_DIR = vim.fn.stdpath("data") .. "/copilot-chats"

local CUSTOM_PROMPTS = {
	-- filetypes
	"angular",
	"js",
	"lua",
	"microbit",
	"react",
	"rust",
	"ts",
	"vim",
	-- operations
	"explain",
	"fix",
	"implement",
	"optimize",
	"refactor",
	-- git
	"codereview",
	"commit",
	"commitwork",
}

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
	javascript = {
		filetypes = { "javascript" },
		prompts = { "js" },
	},
	typescript = {
		filetypes = { "typescript" },
		prompts = { "js", "ts" },
	},
	vim = {
		filetypes = { "vim", "lua" },
		prompts = { "vim", "lua" },
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
	local file_path = vim.fs.joinpath(prompt_dir, string.format("%s.txt", string.lower(basename)))

	local content = vim.fs.read_file(file_path)
	return content or ""
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
	-- Always add communication prompt
	table.insert(prompts, "communication")

	return prompts
end

local function reset_chat()
	local chat = require("CopilotChat")
	vim.g.copilot_chat_title = nil
	chat.reset()
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

local function open_chat()
	local chat = require("CopilotChat")
	local select = require("CopilotChat.select")

	local is_visual_mode = vim.fn.mode():match("[vV]") ~= nil

	vim.cmd("WindowToggleMaximize forceOpen") -- maximize the current window
	vim.cmd("vsplit") -- open a vertical split

	local ft_config = get_config_by_filetype()
	local prompts = get_system_prompts("generic")
	local system_prompt = concat_prompts(prompts)

	reset_chat()

	chat.open({
		contexts = ft_config and ft_config.contexts or {},
		-- if there's something selected use it, if not, use a blank context
		selection = is_visual_mode and select.visual or false,
		system_prompt = system_prompt,
	})
end

local function operation(operation_type)
	local chat = require("CopilotChat")
	local select = require("CopilotChat.select")

	return function()
		vim.cmd("WindowToggleMaximize forceOpen") -- maximize the current window
		vim.cmd("vsplit") -- open a vertical split

		local prompts = get_system_prompts(operation_type)
		local system_prompt = concat_prompts(prompts)
		local prompt = "/" .. operation_type

		reset_chat()

		chat.ask(prompt, {
			auto_insert_mode = false,
			selection = select.visual,
			system_prompt = system_prompt,
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
		local filename = item:match("^.+/(.+)$") or item
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
		sort = {
			fields = { "text:desc" },
		},
		format = function(item)
			local prompt = item.file:match("[0-9]*_[0-9]*_(.+)%.json$")
			local display = " " .. prompt:gsub("[-_]", " "):gsub("^%l", string.upper)

			local mtime = vim.fn.getftime(item.file)
			local date = os.date("%a %d %H:%M", mtime)

			return {
				{ date, "SnacksPickerLabel" },
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
		title = "Copilot Chat History",
	})
end

vim.api.nvim_create_user_command("CopilotCommitMessage", function()
	local chat = require("CopilotChat")

	-- Determine which prompt command to use based on work environment
	local is_work_env = vim.fn.getenv("IS_WORK") == "true"
	local prompt = "/" .. (is_work_env and "commitwork" or "commit")

	chat.reset() -- Reset previous chat state

	-- Get the current buffer
	local bufnr = vim.api.nvim_get_current_buf()

	-- Start spinner animation
	local spinner_idx = 1
	local spinner_timer = vim.uv.new_timer()
	spinner_timer:start(
		0,
		100,
		vim.schedule_wrap(function()
			spinner_idx = (spinner_idx % #icons.spinner) + 1
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
				icons.spinner[spinner_idx] .. " Generating commit message...",
				"",
			})
			vim.cmd("normal! G") -- set cursor on the last line
		end)
	)

	chat.ask(prompt, {
		callback = function(response)
			-- Stop spinner animation
			if spinner_timer then
				spinner_timer:stop()
				spinner_timer:close()
				spinner_timer = nil
			end

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
		selection = false,
		system_prompt = "/COPILOT_INSTRUCTIONS",
	})
end, {})

vim.api.nvim_create_user_command("CopilotCodeReview", function()
	local chat = require("CopilotChat")

	chat.reset() -- Reset previous chat state

	chat.ask("/codereview", {
		callback = function()
			local function accept_code_review()
				chat.close()
				vim.cmd("WindowToggleMaximize forceOpen")
				vim.cmd("vertical Git")
				vim.cmd("Git commit")
			end

			vim.keymap.set({ "n", "i" }, "<c-y>", accept_code_review, { buffer = true })
		end,
		selection = false,
		system_prompt = "/COPILOT_REVIEW",
	})
end, {})

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	keys = function()
		local chat = require("CopilotChat")

		local mappings = {
			-- chat
			{ "<leader>aa", open_chat, "Chat", { mode = { "n", "v" } } },
			{ "<leader>ah", list_chat_history, "List chat history" },
			{ "<leader>am", chat.select_model, "Models" },

			-- predefined prompts
			{ "<leader>ae", operation("explain"), "Explain", { mode = "v" } },
			{ "<leader>af", operation("fix"), "Fix", { mode = "v" } },
			{ "<leader>ai", operation("implement"), "Implement", { mode = "v" } },
			{ "<leader>ao", operation("optimize"), "Optimize", { mode = "v" } },
			{ "<leader>ar", operation("refactor"), "Refactor", { mode = "v" } },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "AI")
	end,
	opts = {
		agent = "copilot",
		answer_header = "  Copilot ",
		question_header = "  ruicsh ",
		auto_insert_mode = true,
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
				normal = "<c-l>",
				insert = "<c-l>",
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
		model = "claude-3.5-sonnet",
		prompts = (function()
			local prompts = {}
			-- Load custom prompts
			for _, prompt in ipairs(CUSTOM_PROMPTS) do
				prompts[prompt] = read_prompt_file(prompt)
			end
			return prompts
		end)(),
		selection = false, -- by default, have no predefined context
		show_help = false,
		window = {
			layout = "replace",
		},
	},

	lazy = false,
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim" },
	},
}
