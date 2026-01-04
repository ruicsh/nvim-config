-- Better vim.ui.input
-- https://github.com/folke/snacks.nvim/blob/main/docs/input.md

return {
	"folke/snacks.nvim",
	opts = {
		input = {},
		styles = {
			input = {
				keys = {
					i_esc = { "<esc>", { "cancel" }, mode = "i", expr = true },
				},
				row = 0.3,
				title_pos = "left",
			},
		},
	},
}
