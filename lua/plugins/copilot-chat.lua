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
	local prompt_dir = vim.fs.joinpath(tostring(vim.fn.stdpath("config")), "prompts")
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

local function open_chat()
	local chat = require("CopilotChat")
	local select = require("CopilotChat.select")

	local is_visual_mode = vim.fn.mode():match("[vV]") ~= nil

	vim.cmd("WindowToggleMaximize") -- maximize the current window
	vim.cmd("vsplit") -- open a vertical split

	local ft_config = get_config_by_filetype()
	local prompts = get_system_prompts("generic")
	local system_prompt = concat_prompts(prompts)

	chat.ask("", {
		clear_chat_on_new_prompt = true,
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
		vim.cmd("WindowToggleMaximize") -- maximize the current window
		vim.cmd("vsplit") -- open a vertical split

		local prompts = get_system_prompts(operation_type)
		local system_prompt = concat_prompts(prompts)

		-- Configure chat parameters
		local chat_config = {
			prompt = "/" .. operation_type,
			options = {
				auto_insert_mode = false,
				clear_chat_on_new_prompt = true,
				selection = select.visual,
				system_prompt = system_prompt,
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
