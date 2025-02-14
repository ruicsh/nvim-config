-- Jump around with search labels
-- https://github.com/folke/flash.nvim

return {
	"folke/flash.nvim",
	keys = function()
		local flash = require("flash")

		local mappings = {
			{ "s", flash.jump, "Jump", { mode = { "n", "o", "v" } } },
			{ "<leader>v", flash.treesitter, "Treesitter", { mode = "n" } },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Flash")
	end,
	opts = {
		highlight = {
			backdrop = false,
		},
		modes = {
			char = {
				enabled = true,
			},
			treesitter = {
				jump = {
					autojump = false,
					pos = "range",
				},
				label = {
					before = true,
					after = false,
					style = "overlay",
				},
			},
		},
	},

	event = { "BufReadPre", "BufNewFile" },
}
