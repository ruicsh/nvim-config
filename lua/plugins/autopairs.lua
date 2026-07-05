-- Auto-pairs.
-- https://github.com/windwp/nvim-autopairs

return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {
		fast_wrap = {
			map = "<c-}>",
			keys = "asdfqwerzxcv",
		},
	},
}
