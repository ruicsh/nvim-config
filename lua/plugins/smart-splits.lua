-- Window navigation and resizing
-- https://github.com/mrjones2014/smart-splits.nvim

return {
	"mrjones2014/smart-splits.nvim",
	keys = function()
		local ss = require("smart-splits")

		local mappings = {
			{ "<c-w>>", ss.resize_right, "Resize split right" },
			{ "<c-w><", ss.resize_left, "Resize split left" },
			{ "<c-w>+", ss.resize_up, "Resize split up" },
			{ "<c-w>-", ss.resize_down, "Resize split down" },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Windows")
	end,
	opts = {
		default_amount = 5,
	},
}
