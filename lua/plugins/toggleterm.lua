-- Terminal windows.
-- https://github.com/akinsho/toggleterm.nvim

local T = require("lib")

return {
	"akinsho/toggleterm.nvim",
	opts = {
		direction = "float",
		float_opts = T.ui.side_panel_win_config(),
		highlights = {
			FloatBorder = { link = "FloatBorder" },
		},
		on_open = function(term)
			vim.opt_local.signcolumn = "yes" -- Show left padding on the window

			local k = function(lhs, rhs, options)
				local opts = vim.tbl_extend("force", { buffer = term.buffer }, options or {})
				vim.keymap.set("t", lhs, rhs, opts)
			end

			k("<c-]>", [[<c-\><c-n>]], { desc = "Exit terminal mode" })
		end,
		open_mapping = "<c-bslash>",
		persist_mode = false,
	},
}
