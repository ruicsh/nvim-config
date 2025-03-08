-- Navigation around the AST tree.
-- https://github.com/aaronik/treewalker.nvim

return {
	"aaronik/treewalker.nvim",
	keys = function()
		local tw = require("treewalker")

		local keymaps = {
			{ "<m-j>", tw.move_down, "Jump to next sibling node", { mode = { "n", "v" } } },
			{ "<m-k>", tw.move_up, "Jump to previous sibling node", { mode = { "n", "v" } } },
			{ "<m-h>", tw.move_out, "Jump to parent", { mode = { "n", "v" } } },
			{ "<m-l>", tw.move_in, "Jump to child", { mode = { "n", "v" } } },
			{ vim.fn.is_windows() and "<m-K>" or "<m-s-k>", tw.swap_up, "Swap up" },
			{ vim.fn.is_windows() and "<m-J>" or "<m-s-j>", tw.swap_down, "Swap down" },
			{ vim.fn.is_windows() and "<m-H>" or "<m-s-h>", tw.swap_left, "Swap left" },
			{ vim.fn.is_windows() and "<m-L>" or "<m-s-l>", tw.swap_right, "Swap right" },
		}

		return vim.fn.get_lazy_keys_conf(keymaps, "AST")
	end,

	event = "BufRead",
}
