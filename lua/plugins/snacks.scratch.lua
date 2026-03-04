-- Scratchpad.
-- https://github.com/folke/snacks.nvim/blob/main/docs/scratch.md

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")
		local scratch = snacks.scratch

		return {
			{ "<leader>e", scratch.open, desc = "Scratchpad: Toggle" },
			{ "<leader>E", scratch.select, desc = "Scratchpad: Select" },
		}
	end)(),
	opts = {
		scratch = {
			ft = "markdown",
			win = {
				footer_keys = false,
				noautocmd = true,
				wo = {
					wrap = true,
				},
			},
		},
	},
}
