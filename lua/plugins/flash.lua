-- Jump around with search labels
-- https://github.com/folke/flash.nvim

return {
	"folke/flash.nvim",
	keys = function()
		local flash = require("flash")
		local mappings = {
			{ "s", flash.jump, "Jump", { mode = { "n", "o", "x" } } },
			{ "<leader>v", flash.treesitter, "Treesitter", { mode = "n" } },
		}
		return vim.fn.getlazykeysconf(mappings, "Flash")
	end,
	opts = {
		highlight = {
			backdrop = false,
		},
		jump = {
			autojump = true,
		},
		modes = {
			search = {
				enabled = true,
			},
			char = {
				enabled = false,
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

	event = { "VeryLazy" },
}
