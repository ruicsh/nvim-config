-- Jump around with search labels
-- https://github.com/folke/flash.nvim

return {
	"folke/flash.nvim",
	keys = function()
		local flash = require("flash")
		local mappings = {
			{ "s", flash.jump, "Jump", { mode = { "n", "o", "x" } } },
			{ "S", flash.treesitter, "Treesitter", { mode = { "n", "o", "x" } } },
		}
		return vim.fn.getlazykeysconf(mappings, "Flash")
	end,
	opts = {
		highlight = {
			backdrop = false,
		},
		modes = {
			search = {
				enabled = true,
			},
			char = {
				highlight = {
					backdrop = false,
				},
			},
		},
	},

	event = { "VeryLazy" },
}
