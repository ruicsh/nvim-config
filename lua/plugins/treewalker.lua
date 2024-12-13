-- Navigation around the AST tree.
-- https://github.com/aaronik/treewalker.nvim

return {
	"aaronik/treewalker.nvim",
	keys = function()
		local tw = require("treewalker")
		return {
			{ "<s-down>", tw.move_down, { desc = "AST: jump to next sibling node" } },
			{ "<s-up>", tw.move_up, { desc = "AST: jump to previous sibling node" } },
			{ "<s-left>", tw.move_out, { desc = "AST: jump to parent" } },
			{ "<s-right>", tw.move_in, { desc = "AST: jump to child" } },
		}
	end,

	event = { "BufRead", "BufNewFile" },
}
