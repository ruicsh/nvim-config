-- Symbols outline
-- https://github.com/stevearc/aerial.nvim

return {
	"stevearc/aerial.nvim",
	opts = {
		attach_mode = "global",
		highlight_on_jump = false,
		ignore = {
			filetypes = { "oil" },
		},
		layout = {
			width = 30,
		},
	},

	cmd = { "AerialToggle", "AerialOpen", "AerialNext", "AerialPrev" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
}
