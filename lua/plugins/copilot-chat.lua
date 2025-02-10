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

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	keys = function()
		local function switch_window(cmd)
			return function()
				vim.cmd("WindowToggleMaximize") -- maximize the current window
				vim.cmd("vsplit") -- open a vertical split
				vim.cmd(cmd) -- issue the CodeCompanion command
			end
		end

		local function show_actions()
			local actions = require("CopilotChat.actions")
			require("CopilotChat.integrations.snacks").pick(actions.prompt_actions())
		end

		local function ask_question()
			require("snacks").input({
				prompt = " Copilot",
			}, function(question)
				if question ~= "" then
					local cmd = "CopilotChat " .. question
					switch_window(cmd)()
				end
			end)
		end

		local function inline_chat()
			require("CopilotChat").open({
				window = {
					col = 1,
					height = 0.4,
					layout = "float",
					relative = "cursor",
					row = 1,
					title = "  Copilot",
					width = 0.3,
				},
			})
		end

		local function switch_custom_prompt()
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
			{ "<leader>aa", switch_window("CopilotChatToggle"), "Chat", { mode = { "n", "x" } } },
			{ "<leader>ac", show_actions, "Actions", { mode = { "n", "v" } } },
			{ "<leader>ae", switch_window("CopilotChatExplain"), "Explain", { mode = { "x" } } },
			{ "<leader>aq", ask_question, "Ask" },
			{ "<leader>ax", inline_chat, "Inline", { mode = { "n", "x" } } },
			{ "<leader>am", ":CopilotChatModels<cr>", "Models" },
			{ "<leader>as", switch_custom_prompt, "Switch prompt" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "AI")
	end,
	opts = {
		answer_header = "  Copilot ",
		auto_insert_mode = true,
		error_header = "  Error ",
		mappings = {
			close = {
				normal = "<c-]>",
				insert = "<c-]>",
			},
		},
		question_header = " ruicsh ",
		prompts = (function()
			local prompts = {}
			for _, prompt in ipairs(custom_prompts) do
				prompts[prompt] = read_prompt_file("dev-" .. prompt)
			end
			return prompts
		end)(),
		show_help = false,
		window = {
			layout = "replace",
		},
	},

	cmd = {
		"CopilotChatOpen",
		"CopilotChatClose",
		"CopilotChatToggle",
		"CopilotChatModels",
	},
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim" },
	},
}
