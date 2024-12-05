-- Better quickfix
-- https://github.com/kevinhwang91/nvim-bqf

return {
	"kevinhwang91/nvim-bqf",
	opts = {
		auto_enable = true,
		auto_resize_height = false,
		preview = {
			win_height = 30,
		},
	},

	main = "bqf",
	ft = { "qf" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
}
