-- Git diff hunks.
-- https://github.com/echasnovski/mini.diff

local icons = require("config/icons")

return {
	"nvim-mini/mini.diff",
	keys = function()
		local diff = require("mini.diff")

		local mappings = {
			{ "<leader>hd", diff.toggle_overlay, "Toggle diff overlay" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Git")
	end,
	opts = {
		view = {
			style = "sign",
			signs = {
				add = icons.git.Add,
				change = icons.git.Change,
				delete = icons.git.Delete,
			},
		},
		mappings = {
			apply = "gh",
			reset = "gH",
			textobject = "gh",
			goto_first = "[C",
			goto_prev = "[c",
			goto_next = "]c",
			goto_last = "]C",
		},
	},

	event = "BufRead",
}
