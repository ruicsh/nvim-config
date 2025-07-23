-- Navigation around the AST tree.
-- https://github.com/aaronik/treewalker.nvim

return {
	"aaronik/treewalker.nvim",
	keys = function()
		local tw = require("treewalker")

		local keymaps = {
			{ "<c-h>", tw.move_out, "Jump to parent", { mode = { "n", "v" } } },
			{ "<c-j>", tw.move_down, "Jump to next sibling node", { mode = { "n", "v" } } },
			{ "<c-k>", tw.move_up, "Jump to previous sibling node", { mode = { "n", "v" } } },
			{ "<c-l>", tw.move_in, "Jump to child", { mode = { "n", "v" } } },
			{ "<a-h>", tw.swap_left, "Swap left" },
			{ "<a-j>", tw.swap_down, "Swap down" },
			{ "<a-k>", tw.swap_up, "Swap up" },
			{ "<a-l>", tw.swap_right, "Swap right" },
		}

		return vim.fn.get_lazy_keys_conf(keymaps, "AST")
	end,
	opts = {
		highlight = true,
		jumplist = false,
	},
}
