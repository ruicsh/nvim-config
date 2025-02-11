-- GitHub Copilot Chat
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim

-- Custom prompts to be used with the `:CopilotChat` command
local custom_prompts = {
	"angular",
	"js",
	"microbit",
	"react",
	"rust",
	"ts",
	"vim",
}

-- Read the contents of a prompt file given its basename
local function read_prompt_file(basename)
	local config_path = vim.fn.stdpath("config")
	local file_path = config_path .. "/prompts/" .. basename .. ".txt"
	return vim.fs.read_file(string.lower(file_path))
end

vim.api.nvim_create_user_command("CopilotChatGenCommitMessage", function()
	local chat = require("CopilotChat")
	local config = require("CopilotChat.config")

	chat.ask(config.prompts.Commit.prompt, {
		clear_chat_on_new_prompt = true,
		model = "gemini-2.0-flash-001",
		window = {
			col = 1,
			height = 20,
			layout = "float",
			relative = "cursor",
			row = 1,
			title = "  Commit message",
			width = 80,
		},
	})
end, {})

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	keys = function()
		local chat = require("CopilotChat")
		local actions = require("CopilotChat.actions")
		local select = require("CopilotChat.select")

		local function switch_window(cmd)
			return function()
				vim.cmd("WindowToggleMaximize") -- maximize the current window
				vim.cmd("vsplit") -- open a vertical split
				vim.cmd(cmd) -- issue the command
			end
		end

		local function show_actions()
			require("CopilotChat.integrations.snacks").pick(actions.prompt_actions())
		end

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

		local function inline_chat()
			chat.open({
				clear_chat_on_new_prompt = true,
				selection = select.visual,
				window = {
					col = 1,
					height = 0.4,
					layout = "float",
					relative = "cursor",
					row = 1,
					title = "  Inline",
					width = 0.3,
				},
			})
		end

		local function switch_prompt()
			vim.ui.select(custom_prompts, {
				prompt = "Select a custom prompt",
				format_item = function(item)
					return item
				end,
			}, function(choice)
				local cmd = "CopilotChat" .. choice

				local ft = vim.bo.filetype
				if ft ~= "copilot-chat" then
					switch_window(cmd)()
				else
					vim.cmd(cmd)
				end
			end)
		end

		local mappings = {
			{ "<leader>aa", switch_window("CopilotChatOpen"), "Chat", { mode = "v" } },
			{ "<leader>aa", switch_window("CopilotChatToggle"), "Chat" },
			{ "<leader>ac", show_actions, "Actions", { mode = { "n", "v" } } },
			{ "<leader>ae", switch_window("CopilotChatExplain"), "Explain", { mode = { "v" } } },
			{ "<leader>ai", inline_chat, "Inline", { mode = { "n", "v" } } },
			{ "<leader>am", chat.select_model, "Models" },
			{ "<leader>ap", switch_prompt, "Switch prompt" },
			{ "<leader>aq", ask_question, "Ask" },
			{ "<leader>as", chat.stop, "Stop" },
			{ "<leader>ax", chat.reset, "Reset" },
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
			for _, prompt in ipairs(custom_prompts) do
				prompts[prompt] = read_prompt_file("dev-" .. prompt)
			end
			return prompts
		end)(),
		show_help = false,
		sticky = {
			"/COPILOT_GENERATE",
		},
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
