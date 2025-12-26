-- Navigation around the AST tree.
-- https://github.com/aaronik/treewalker.nvim

return {
	"aaronik/treewalker.nvim",
	keys = function()
		local tw = require("treewalker")

		local mappings = {
			{ "<c-h>", tw.move_out, desc = "AST: Jump to parent", mode = { "n", "v" } },
			{ "<c-j>", tw.move_down, desc = "AST: Jump to next sibling node", mode = { "n", "v" } },
			{ "<c-k>", tw.move_up, desc = "AST: Jump to previous sibling node", mode = { "n", "v" } },
			{ "<c-l>", tw.move_in, desc = "AST: Jump to child", mode = { "n", "v" } },
		}

		if vim.fn.is_windows() then
			table.insert(mappings, { "<c-H>", tw.swap_left, desc = "AST: Swap left" })
			table.insert(mappings, { "<c-J>", tw.swap_down, desc = "AST: Swap down" })
			table.insert(mappings, { "<c-K>", tw.swap_up, desc = "AST: Swap up" })
			table.insert(mappings, { "<c-L>", tw.swap_right, desc = "AST: Swap right" })
		else
			table.insert(mappings, { "<c-s-h>", tw.swap_left, desc = "AST: Swap left" })
			table.insert(mappings, { "<c-s-j>", tw.swap_down, desc = "AST: Swap down" })
			table.insert(mappings, { "<c-s-k>", tw.swap_up, desc = "AST: Swap up" })
			table.insert(mappings, { "<c-s-l>", tw.swap_right, desc = "AST: Swap right" })
		end

		return mappings
	end,
	opts = {
		highlight = true,
		jumplist = "left",
	},
}
