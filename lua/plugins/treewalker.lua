-- Navigation around the AST tree.
-- https://github.com/aaronik/treewalker.nvim

return {
	"aaronik/treewalker.nvim",
	keys = function()
		local tw = require("treewalker")

		local keymaps = {
			{ "<c-j>", tw.move_down, "Jump to next sibling node", { mode = { "n", "v" } } },
			{ "<c-k>", tw.move_up, "Jump to previous sibling node", { mode = { "n", "v" } } },
			{ "<c-h>", tw.move_out, "Jump to parent", { mode = { "n", "v" } } },
			{ "<c-l>", tw.move_in, "Jump to child", { mode = { "n", "v" } } },
			{ "<m-k>", tw.swap_up, "Swap up" },
			{ "<m-j>", tw.swap_down, "Swap down" },
			{ "<m-h>", tw.swap_left, "Swap left" },
			{ "<m-l>", tw.swap_right, "Swap right" },
		}

		return vim.fn.get_lazy_keys_conf(keymaps, "AST")
	end,

	enabled = not vim.g.vscode,
}
