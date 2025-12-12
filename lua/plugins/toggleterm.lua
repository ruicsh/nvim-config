-- Terminal windows.
-- https://github.com/akinsho/toggleterm.nvim

return {
	"akinsho/toggleterm.nvim",
	opts = {
		direction = "float",
		float_opts = {
			anchor = "NE",
			border = { "", "", "", "", "", "", "", "│" },
			col = vim.o.columns,
			height = vim.o.lines - vim.o.cmdheight - 1,
			relative = "editor",
			row = 0,
			style = "minimal",
			width = math.floor(vim.o.columns * 0.5),
		},
		highlights = {
			FloatBorder = { link = "FloatBorder" },
		},
		on_open = function()
			vim.opt_local.signcolumn = "yes" -- Show left padding on the window
		end,
		open_mapping = "<c-t>",
	},
}
