-- Auto-close/rename html tags.
-- https://github.com/windwp/nvim-ts-autotag

return {
	"windwp/nvim-ts-autotag",
	options = {
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = true,
		},
		aliases = {
			["htmlangular"] = "html",
		},
	},
	config = function(_, opts)
		local autotag = require("nvim-ts-autotag")
		autotag.setup(opts)
	end,

	ft = { "html", "htmlangular", "typescript", "typescriptreact", "vue" },
	event = "BufRead",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter" },
	},
}
