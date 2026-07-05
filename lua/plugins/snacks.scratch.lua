-- Scratchpad.
-- https://github.com/folke/snacks.nvim/blob/main/docs/scratch.md

return {
	"folke/snacks.nvim",
	keys = {
		{ "<leader>e", function() require("snacks").scratch.open() end, desc = "Scratchpad: Toggle" },
		{ "<leader>E", function() require("snacks").scratch.select() end, desc = "Scratchpad: Select" },
	},
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
