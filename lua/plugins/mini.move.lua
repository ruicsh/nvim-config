-- Move selection/lines
-- https://github.com/echasnovski/mini.move

return {
	"echasnovski/mini.move",
	opts = {
		mappings = {
			-- Move visual selection in Visual mode.
			left = "<",
			right = ">",
			down = "]e",
			up = "[e",

			-- Move current line in Normal mode
			line_left = "",
			line_right = "",
			line_down = "]e",
			line_up = "[e",
		},
	},
}
