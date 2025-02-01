-- AI chat and inline assistant.
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
		adapters = {
			anthropic = function()
				return require("codecompanion.adapters").extend("anthropic", {
					env = {
						ANTHROPIC_API_KEY = vim.fn.getenv("ANTHROPIC_API_KEY"),
					},
				})
			end,
			copilot = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "gpt-4o-2024-08-06",
						},
					},
				})
			end,
			openai = function()
				return require("codecompanion.adapters").extend("openai", {
					env = {
						OPENAI_API_KEY = vim.fn.getenv("OPENAI_API_KEY"),
					},
				})
			end,
		},
		display = {
			chat = {
				intro_message = "Press ? for options",
				show_header_separator = true,
				separator = "──",
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
					user = "Me",
					llm = function(adapter)
						return adapter.formatted_name .. " ㋶"
					end,
				},
				keymaps = {
					previous_chat = {
						modes = {
							n = "<tab>",
						},
					},
					next_chat = {
						modes = {
							n = "<s-tab>",
						},
					},
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
