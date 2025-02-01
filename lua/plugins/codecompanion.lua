-- AI chat and inline assisntant.
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
				intro_message = "Press ? for options",
				window = {
					layout = "buffer",
					opts = {
						cursorline = true,
						foldcolumn = "1",
						numberwidth = 5,
						signcolumn = "yes",
					},
				},
			},
		},
		strategies = {
			chat = {
				adapter = "copilot",
				roles = {
					user = "ruic",
					llm = function(adapter)
						return adapter.formatted_name
					end,
				},
			},
			inline = {
				adapter = "copilot",
			},
		},
	},
	config = function(_, opts)
		local cc = require("codecompanion")
		cc.setup(opts)
		vim.cmd([[cab cc CodeCompanion]]) -- shortcut on the cmdline
	end,

	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"nvim-treesitter/nvim-treesitter",
	},
}
