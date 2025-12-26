-- Window navigation and resizing
-- https://github.com/mrjones2014/smart-splits.nvim

return {
	"mrjones2014/smart-splits.nvim",
	keys = function()
		local ss = require("smart-splits")

		return {
			{ "<c-w>>", ss.resize_right, "Windows: Resize right" },
			{ "<c-w><", ss.resize_left, "Windows: Resize left" },
			{ "<c-w>+", ss.resize_up, "Windows: Resize up" },
			{ "<c-w>-", ss.resize_down, "Windows: Resize down" },
		}
	end,
	opts = {
		default_amount = 5,
	},
}
