-- Enhanced f/t motions for Leap
-- https://github.com/ggandor/flit.nvim

return {
	"ggandor/flit.nvim",
	opts = {
		labeled_modes = "v",
	},

	dependencies = {
		"ggandor/leap.nvim",
		"tpope/vim-repeat",
	},
}
