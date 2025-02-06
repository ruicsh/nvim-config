-- Move line/selection up/down.
-- https://github.com/echasnovski/mini.move

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

	event = { "BufReadPre", "BufNewFile" },
}
