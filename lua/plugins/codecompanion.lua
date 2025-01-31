-- AI chat
-- https://codecompanion.olimorris.dev/

return {
	"olimorris/codecompanion.nvim",
	keys = function()
		local mappings = {
			{ "<c-a>", ":CodeCompanionActions<cr>", "Actions", { mode = { "n", "v" } } },
			{ "<leader>a", ":CodeCompanionChat Toggle<cr>", "Chat", { mode = { "n", "v" } } },
			{ "ga", ":CodeCompanionChat Add<cr>", "Add", { mode = { "v" } } },
		}
		return vim.fn.getlazykeysconf(mappings, "AI")
	end,
	opts = {
		display = {
			chat = {
				window = {
					layout = "buffer",
				},
			},
		},
		strategies = {
			chat = {
				adapter = "copilot",
			},
			inline = {
				adapter = "copilot",
			},
		},
	},
	config = true,

	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"nvim-treesitter/nvim-treesitter",
	},
}
