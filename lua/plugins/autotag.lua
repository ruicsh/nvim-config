-- Auto close and rename HTML tags
-- https://github.com/windwp/nvim-ts-autotag

return {
	"windwp/nvim-ts-autotag",
	opts = {
		opts = {
			enable_close = true, -- Auto close tags
			enable_rename = true, -- Auto rename pairs of tags
			enable_close_on_slash = true, -- Auto close on trailing </
		},
	},
	event = "InsertEnter",
}
