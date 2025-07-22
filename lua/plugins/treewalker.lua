-- Navigation around the AST tree.
-- https://github.com/aaronik/treewalker.nvim

return {
	"aaronik/treewalker.nvim",
	keys = function()
		local tw = require("treewalker")

		local keymaps = {
			{ "<c-h>", tw.swap_left, "Swap left" },
			{ "<c-j>", tw.swap_down, "Swap down" },
			{ "<c-k>", tw.swap_up, "Swap up" },
			{ "<c-l>", tw.swap_right, "Swap right" },
		}

		return vim.fn.get_lazy_keys_conf(keymaps, "AST")
	end,
	opts = {
		highlight = true,
		jumplist = false,
	},
}
