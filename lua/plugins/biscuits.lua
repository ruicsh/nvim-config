-- Annotations at the end of a closing tag/bracket/parenthesis
-- https://github.com/code-biscuits/nvim-biscuits

return {
	"code-biscuits/nvim-biscuits",
	opts = {
		cursor_line_only = true,
		show_on_start = false,
	},

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
}
