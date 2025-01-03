-- Navigation around the AST tree.
-- https://github.com/aaronik/treewalker.nvim

return {
	"aaronik/treewalker.nvim",
	keys = function()
		local tw = require("treewalker")
		local keymaps = {
			{ "<s-down>", tw.move_down, "Jump to next sibling node" },
			{ "<s-up>", tw.move_up, "Jump to previous sibling node" },
			{ "<s-left>", tw.move_out, "Jump to parent" },
			{ "<s-right>", tw.move_in, "Jump to child" },
		}
		return vim.fn.getlazykeysconf(keymaps, "AST")
	end,

	event = { "BufRead", "BufNewFile" },
}
