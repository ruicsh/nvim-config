-- Window navigation and resizing
-- https://github.com/mrjones2014/smart-splits.nvim

return {
	"mrjones2014/smart-splits.nvim",
	keys = function()
		local ss = require("smart-splits")

		return {
			{ "<c-w>>", ss.resize_right, desc = "Windows: Resize right" },
			{ "<c-w><", ss.resize_left, desc = "Windows: Resize left" },
			{ "<c-w>+", ss.resize_up, desc = "Windows: Resize up" },
			{ "<c-w>-", ss.resize_down, desc = "Windows: Resize down" },
		}
	end,
	opts = {
		resize = {
			amount = 5,
		},
	},
}
