-- Navigation around the AST tree.
-- https://github.com/aaronik/treewalker.nvim

return {
	"aaronik/treewalker.nvim",
	keys = function()
		local tw = require("treewalker")

		local mappings = {
			{ "<c-h>", tw.move_out, "Jump to parent", { mode = { "n", "v" } } },
			{ "<c-j>", tw.move_down, "Jump to next sibling node", { mode = { "n", "v" } } },
			{ "<c-k>", tw.move_up, "Jump to previous sibling node", { mode = { "n", "v" } } },
			{ "<c-l>", tw.move_in, "Jump to child", { mode = { "n", "v" } } },
		}

		if vim.fn.is_windows() then
			table.insert(mappings, { "<c-H>", tw.swap_left, "Swap left" })
			table.insert(mappings, { "<c-J>", tw.swap_down, "Swap down" })
			table.insert(mappings, { "<c-K>", tw.swap_up, "Swap up" })
			table.insert(mappings, { "<c-L>", tw.swap_right, "Swap right" })
		else
			table.insert(mappings, { "<c-s-h>", tw.swap_left, "Swap left" })
			table.insert(mappings, { "<c-s-j>", tw.swap_down, "Swap down" })
			table.insert(mappings, { "<c-s-k>", tw.swap_up, "Swap up" })
			table.insert(mappings, { "<c-s-l>", tw.swap_right, "Swap right" })
		end

		return vim.fn.get_lazy_keys_config(mappings, "AST")
	end,
	opts = {
		highlight = true,
		jumplist = "left",
	},
}
