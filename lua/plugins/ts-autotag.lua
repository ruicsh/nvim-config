-- Auto-close/rename html tags
-- https://github.com/windwp/nvim-ts-autotag

return {
	"windwp/nvim-ts-autotag",
	options = {
		opts = {
			enable_close = true, -- Auto close tags.
			enable_rename = true, -- Auto rename pairs of tags.
			enable_close_on_slash = true, -- Auto close on trailing </.
		},
	},

	main = "nvim-ts-autotag",
	ft = { "html", "htmlangular", "typescript", "typescriptreact", "vue" },
}
