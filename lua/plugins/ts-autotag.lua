-- Auto-close/rename html tags.
-- https://github.com/windwp/nvim-ts-autotag

return {
	"windwp/nvim-ts-autotag",
	opts = {
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = true,
		},
		aliases = {
			["htmlangular"] = "html",
		},
	},

	ft = { "html", "htmlangular", "typescript", "typescriptreact", "vue" },
	main = "nvim-ts-autotag",
	event = "BufRead",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter" },
	},
}
