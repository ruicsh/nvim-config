-- Navigation around the AST tree.
-- https://github.com/aaronik/treewalker.nvim

return {
	"aaronik/treewalker.nvim",
	keys = function()
		local tw = require("treewalker")

		local keymaps = {
			{ "`[", tw.move_out, "Jump to parent", { mode = { "n", "v" } } },
			{ "`n", tw.move_down, "Jump to next sibling node", { mode = { "n", "v" } } },
			{ "`p`", tw.move_up, "Jump to previous sibling node", { mode = { "n", "v" } } },
			{ "`]", tw.move_in, "Jump to child", { mode = { "n", "v" } } },
			{ "`h", tw.swap_left, "Swap left" },
			{ "`j", tw.swap_down, "Swap down" },
			{ "`k", tw.swap_up, "Swap up" },
			{ "`l", tw.swap_right, "Swap right" },
		}

		return vim.fn.get_lazy_keys_conf(keymaps, "AST")
	end,
	opts = {
		highlight = true,
		jumplist = false,
	},
}
