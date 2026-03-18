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
		open_mapping = "<c-bslash>",
		persist_mode = false,
	},
}
