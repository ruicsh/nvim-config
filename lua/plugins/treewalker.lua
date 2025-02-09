-- Navigation around the AST tree.
-- https://github.com/aaronik/treewalker.nvim

return {
	"aaronik/treewalker.nvim",
	keys = function()
		local tw = require("treewalker")

		local keymaps = {
			{ "<s-down>", tw.move_down, "Jump to next sibling node", { mode = { "n", "x" } } },
			{ "<s-up>", tw.move_up, "Jump to previous sibling node", { mode = { "n", "x" } } },
			{ "<s-left>", tw.move_out, "Jump to parent", { mode = { "n", "x" } } },
			{ "<s-right>", tw.move_in, "Jump to child", { mode = { "n", "x" } } },
		}

		local keymaps_swap = {}
		if vim.fn.is_windows() then
			keymaps_swap = {
				{ "<c-K>", tw.swap_up, "Swap up" },
				{ "<c-J>", tw.swap_down, "Swap down" },
				{ "<c-H>", tw.swap_left, "Swap left" },
				{ "<c-L>", tw.swap_right, "Swap right" },
			}
		else
			keymaps_swap = {
				{ "<c-s-k>", tw.swap_up, "Swap up" },
				{ "<c-s-j>", tw.swap_down, "Swap down" },
				{ "<c-s-h>", tw.swap_left, "Swap left" },
				{ "<c-s-l>", tw.swap_right, "Swap right" },
			}
		end

		for _, k in ipairs(keymaps_swap) do
			table.insert(keymaps, k)
		end

		return vim.fn.get_lazy_keys_conf(keymaps, "AST")
	end,

	event = { "BufRead", "BufNewFile" },
}
