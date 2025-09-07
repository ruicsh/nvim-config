-- Git diff hunks.
-- https://github.com/nvim-mini/mini.diff

local icons = require("core.icons")

return {
	"nvim-mini/mini.diff",
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
			apply = "",
			reset = "",
			textobject = "",
			goto_first = "[C",
			goto_prev = "[c",
			goto_next = "]c",
			goto_last = "]C",
		},
	},

	event = "BufRead",
}
