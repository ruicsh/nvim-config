-- Zen mode and zoom.
-- https://github.com/folke/snacks.nvim/blob/main/docs/zen.md

local T = require("lib")

return {
	"folke/snacks.nvim",
	keys = {
		{ "<leader>z", function() require("snacks").zen.zen() end, desc = "ZenMode: Toggle" },
		{ "<c-w>z", function() require("snacks").zen.zoom() end, desc = "ZenMode: Zoom" },
	},
	opts = {
		zen = {
			toggles = {
				dim = false,
			},
			win = {
				keys = {
					["q"] = false,
					["<leader>z"] = false,
				},
				width = T.env.get_number("ZEN_MODE_WINDOW_WIDTH"),
				zindex = 100,
			},
		},
	},
}
