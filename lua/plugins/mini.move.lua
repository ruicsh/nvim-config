-- Move any selection in any direction
-- https://github.com/nvim-mini/mini.move

return {
	"nvim-mini/mini.move",

	opts = {
		mappings = {
			-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
			left = "<a-left>",
			right = "<a-right>",
			down = "<a-down>",
			up = "<a-up>",

			-- Move current line in Normal mode
			line_left = "<a-left>",
			line_right = "<a-right>",
			line_down = "<a-down>",
			line_up = "<a-up>",
		},
	},
}
