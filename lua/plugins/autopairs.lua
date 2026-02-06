-- Auto-pairs.
-- https://github.com/windwp/nvim-autopairs

return {
	"windwp/nvim-autopairs",
	opts = {
		fast_wrap = {
			map = "<c-}>",
			keys = "asdfqwerzxcv",
		},
	},

	event = "InsertEnter",
}
