-- Navigation around the AST tree.
-- https://github.com/aaronik/treewalker.nvim

return {
	"aaronik/treewalker.nvim",
	keys = function()
		local tw = require("treewalker")

		local keymaps = {
			{ "<s-down>", tw.move_down, "Jump to next sibling node", { mode = { "n", "v" } } },
			{ "<s-up>", tw.move_up, "Jump to previous sibling node", { mode = { "n", "v" } } },
			{ "<s-left>", tw.move_out, "Jump to parent", { mode = { "n", "v" } } },
			{ "<s-right>", tw.move_in, "Jump to child", { mode = { "n", "v" } } },
			{ "<m-up>", tw.swap_up, "Swap up" },
			{ "<m-down>", tw.swap_down, "Swap down" },
			{ "<m-left>", tw.swap_left, "Swap left" },
			{ "<m-right>", tw.swap_right, "Swap right" },
		}

		return vim.fn.get_lazy_keys_conf(keymaps, "AST")
	end,

	enabled = not vim.g.vscode,
}
