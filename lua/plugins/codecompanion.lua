-- AI chat and inline assistant.
-- https://codecompanion.olimorris.dev/

return {
	"olimorris/codecompanion.nvim",
	keys = function()
		local function switch_window(cmd)
			return function()
				vim.cmd.wincmd("w")
				vim.cmd(cmd)
			end
		end

		local mappings = {
			{ "<leader>aa", switch_window("CodeCompanionChat"), "Chat", { mode = { "n", "v" } } },
			{ "<leader>ae", switch_window("CodeCompanion /explain"), "Explain", { mode = { "v" } } },
			{ "<leader>ac", ":CodeCompanionActions<cr>", "Actions", { mode = { "n", "v" } } },
			{ "<c-a>", ":CodeCompanionChat Toggle<cr>", "Chat", { mode = { "n", "v" } } },
			{ "ga", ":CodeCompanionChat Add<cr>", "Add", { mode = { "v" } } },
		}
		return vim.fn.get_lazy_keys_conf(mappings, "AI")
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
				separator = "──",
				show_header_separator = true,
				show_references = true,
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

	cmd = {
		"CodeCompanion",
		"CodeCompanionActions",
		"CodeCompanionChat",
		"CodeCompanionCmd",
	},
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"nvim-treesitter/nvim-treesitter",
	},
}
