-- Better quickfix window
-- https://github.com/kevinhwang91/nvim-bqf

return {
	"kevinhwang91/nvim-bqf",
	opts = {
		preview = {
			win_height = 25,
			winblend = 0,
		},
	},

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
}
