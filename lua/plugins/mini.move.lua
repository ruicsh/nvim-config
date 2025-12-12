-- Move any selection in any direction
-- https://github.com/nvim-mini/mini.move

return {
	"nvim-mini/mini.move",

	opts = {
		mappings = {
			-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
			down = "<a-j>",
			left = "<a-h>",
			right = "<a-l>",
			up = "<a-k>",

			-- Move current line in Normal mode
			line_down = "<a-j>",
			line_left = "<a-h>",
			line_right = "<a-l>",
			line_up = "<a-k>",
		},
	},
}
