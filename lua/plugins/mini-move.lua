-- Move line/selection up/down
-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-move.md

return {
	"echasnovski/mini.move",
	opts = {
		mappings = {
			down = "]e",
			up = "[e",
			line_up = "[e",
			line_down = "]e",
		},
		options = {
			reindent_linewise = true,
		},
	},

	event = { "VeryLazy" },
}
