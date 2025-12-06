-- Terminal windows.
-- https://github.com/akinsho/toggleterm.nvim

return {
	"akinsho/toggleterm.nvim",
	opts = {
		direction = "float",
		float_opts = {
			border = { "", "", "", "", "", "", "", "│" },
			width = math.floor(vim.o.columns * 0.5),
			height = vim.o.lines - vim.o.cmdheight - 1,
			row = 0,
			col = math.floor(vim.o.columns * 0.5) + 1,
		},
		highlights = {
			FloatBorder = { link = "FloatBorder" },
		},
		open_mapping = "<c-t>",
	},
}
