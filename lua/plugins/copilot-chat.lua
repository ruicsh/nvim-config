-- GitHub Copilot Chat
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim

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

		local mappings = {
			{ "<leader>aa", switch_window("CopilotChatToggle"), "Chat", { mode = { "n", "v" } } },
			{ "<leader>ae", switch_window("CopilotChatExplain"), "Explain", { mode = { "v" } } },
			-- { "<leader>ac", ":CodeCompanionActions<cr>", "Actions", { mode = { "n", "v" } } },
			-- { "ga", switch_window("CodeCompanionChat Add"), "Add", { mode = { "v" } } },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "AI")
	end,
	opts = {
		window = {
			layout = "replace",
		},
		highlight_selection = false,
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
