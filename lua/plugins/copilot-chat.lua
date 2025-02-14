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
	"codereview",
	"commit",
	"commitwork",
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
	local prompt_dir = vim.fs.joinpath(tostring(vim.fn.stdpath("config")), "prompts")
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

local function get_system_prompt(action)
	local ft_prompt = get_system_prompt_by_filetype()
	local prompt_type = (action == "explain") and "COPILOT_EXPLAIN" or "COPILOT_GENERATE"

	return "> /" .. prompt_type .. ft_prompt
end

local function open_chat()
	local chat = require("CopilotChat")
	local select = require("CopilotChat.select")

	local is_visual_mode = vim.fn.mode():match("[vV]") ~= nil

	vim.cmd("WindowToggleMaximize") -- maximize the current window
	vim.cmd("vsplit") -- open a vertical split

	local system_prompt = "> /COPILOT_INSTRUCTIONS" .. get_system_prompt_by_filetype()

	chat.ask("", {
		clear_chat_on_new_prompt = true,
		-- if there's something selected use it, if not, use a blank context
		selection = is_visual_mode and select.visual or false,
		system_prompt = system_prompt,
	})
end

local function operation(operation_type)
	local chat = require("CopilotChat")
	local select = require("CopilotChat.select")

	return function()
		vim.cmd("WindowToggleMaximize") -- maximize the current window
		vim.cmd("vsplit") -- open a vertical split

		-- Configure chat parameters
		local chat_config = {
			prompt = "/" .. operation_type,
			options = {
				auto_insert_mode = false,
				clear_chat_on_new_prompt = true,
				selection = select.visual,
				system_prompt = get_system_prompt(operation_type),
			},
		}

		-- Initialize chat with error handling
		chat.ask(chat_config.prompt, chat_config.options)
	end
end

vim.api.nvim_create_user_command("CopilotCommitMessage", function()
	local chat = require("CopilotChat")
	local select = require("CopilotChat.select")

	-- Determine which prompt command to use based on work environment
	local is_work_env = vim.fn.getenv("IS_WORK") == "true"
	local prompt = "/" .. (is_work_env and "commitwork" or "commit")

	chat.ask(prompt, {
		clear_chat_on_new_prompt = true,
		selection = select.buffer,
		system_prompt = "/COPILOT_INSTRUCTIONS",
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

	chat.ask("/codereview", {
		clear_chat_on_new_prompt = true,
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
		selection = false,
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
