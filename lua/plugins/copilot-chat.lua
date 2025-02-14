-- GitHub Copilot Chat
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim

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
	"commit",
	"commitwork",
	"codereview",
}

local FILETYPE_PROMPTS = {
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
	local prompt_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "prompts")
	local file_path = vim.fs.joinpath(prompt_dir, string.format("%s.txt", string.lower(basename)))

	local content = vim.fs.read_file(file_path)
	return content or ""
end

local function get_system_prompt_by_filetype()
	local ft = vim.bo.filetype
	local filename = vim.fn.expand("%:t")
	local prompts = {}

	for _, config in pairs(FILETYPE_PROMPTS) do
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
			vim.list_extend(prompts, config.prompts)
		end
	end

	-- Always add communication prompt
	table.insert(prompts, "communication")

	-- Construct final prompt
	return table.concat(
		vim.tbl_map(function(p)
			return "\n> /" .. p
		end, prompts),
		""
	)
end

local function switch_window(cmd)
	return function()
		vim.cmd("WindowToggleMaximize") -- maximize the current window
		vim.cmd("vsplit") -- open a vertical split
		vim.cmd(cmd) -- issue the command
	end
end

vim.api.nvim_create_user_command("CopilotCommitMessage", function()
	local chat = require("CopilotChat")
	local config = require("CopilotChat.config")

	-- Determine which prompt command to use based on work environment
	local is_work_env = vim.fn.getenv("IS_WORK") == "true"
	local prompt = "/" .. (is_work_env and "commitwork" or "commit")

	chat.ask(prompt, {
		clear_chat_on_new_prompt = true,
		system_prompt = config.prompts.COPILOT_INSTRUCTIONS.system_prompt,
		window = {
			col = 1,
			height = 20,
			layout = "float",
			relative = "cursor",
			row = 1,
			title = "  Commit",
			width = 80,
		},
	})
end, {})

vim.api.nvim_create_user_command("CopilotCodeReview", function()
	local chat = require("CopilotChat")
	local config = require("CopilotChat.config")

	local system_prompt = read_prompt_file("code_review")
	local prompt = [[
> #git:staged

Review my staged code files before I commit them.
  ]]

	chat.ask(prompt, {
		callback = config.prompts.Review.callback,
		clear_chat_on_new_prompt = true,
		system_prompt = system_prompt,
	})
end, {})

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	keys = function()
		local chat = require("CopilotChat")

		local function ask_question()
			require("snacks").input({
				prompt = " Copilot",
			}, function(input)
				if input ~= "" then
					local cmd = "CopilotChat " .. input
					switch_window(cmd)()
				end
			end)
		end

		local function switch_prompt()
			vim.ui.select(CUSTOM_PROMPTS, {
				prompt = "Select a custom prompt",
				format_item = function(item)
					return item
				end,
			}, function(choice)
				if not choice then
					return
				end

				local cmd = "CopilotChat" .. choice
				local ft = vim.bo.filetype
				if ft ~= "copilot-chat" then
					switch_window(cmd)()
				else
					vim.cmd(cmd)
				end
			end)
		end

		local function get_chat_system_prompt(action)
			local ft_prompt = get_system_prompt_by_filetype()
			local prompt_type = (action == "explain") and "COPILOT_EXPLAIN" or "COPILOT_GENERATE"

			return "> /" .. prompt_type .. ft_prompt
		end

		local function operation(operation_type)
			return function()
				vim.cmd("WindowToggleMaximize") -- maximize the current window
				vim.cmd("vsplit") -- open a vertical split

				-- Configure chat parameters
				local chat_config = {
					prompt = "/" .. operation_type,
					options = {
						auto_insert_mode = false,
						clear_chat_on_new_prompt = true,
						model = "claude-3.5-sonnet",
						system_prompt = get_chat_system_prompt(operation_type),
					},
				}

				-- Initialize chat with error handling
				chat.ask(chat_config.prompt, chat_config.options)
			end
		end

		local mappings = {
			-- chat
			{ "<leader>aa", switch_window("CopilotChatToggle"), "Chat" },
			{ "<leader>am", chat.select_model, "Models" },
			{ "<leader>ap", switch_prompt, "Switch prompt" },
			{ "<leader>aq", ask_question, "Ask" },
			{ "<c-]>", chat.stop, "Stop" },

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
		answer_header = "  Copilot ",
		auto_insert_mode = true,
		chat_autocomplete = false,
		error_header = "  Error ",
		insert_at_end = true,
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
			show_diff = {
				full_diff = true,
			},
			yank_diff = {
				normal = "gy",
				register = "+",
			},
		},
		model = "claude-3.5-sonnet",
		question_header = "  ruicsh ",
		prompts = (function()
			local prompts = {}
			-- Load custom prompts
			for _, prompt in ipairs(CUSTOM_PROMPTS) do
				prompts[prompt] = read_prompt_file(prompt)
			end
			return prompts
		end)(),
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
