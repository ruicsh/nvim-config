-- Zen mode and zoom.
-- https://github.com/folke/snacks.nvim/blob/main/docs/zen.md

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")
		local zen = snacks.zen

		return {
			{ "<leader>z", zen.zen, desc = "ZenMode: Toggle" },
			{ "<c-w>z", zen.zoom, desc = "ZenMode: Zoom" },
		}
	end)(),
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
				width = tonumber(vim.fn.env_get("ZEN_MODE_WINDOW_WIDTH")),
				zindex = 100,
			},
		},
	},
}
