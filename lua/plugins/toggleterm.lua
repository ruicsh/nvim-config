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
		on_open = function(term)
			vim.opt_local.signcolumn = "yes" -- Show left padding on the window

			local k = function(lhs, rhs, options)
				local opts = vim.tbl_extend("force", { buffer = term.buffer }, options or {})
				vim.keymap.set("t", lhs, rhs, opts)
			end

			k("<c-[>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
		end,
		open_mapping = "<c-t>",
	},
}
