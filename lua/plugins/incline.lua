-- Floating winbar.
-- https://github.com/b0o/incline.nvim

return {
	"b0o/incline.nvim",
	opts = {
		hide = {
			cursorline = true,
		},
		render = function(props)
			local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
			local modified = vim.bo[props.buf].modified
			return {
				filename,
				modified and { " [*]", guifg = vim.g.theme_colors.nord13 } or "",
			}
		end,
	},

	event = "VeryLazy",
}
