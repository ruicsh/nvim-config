-- Breadcrumbs
-- https://github.com/utilyre/barbecue.nvim

return {
	"utilyre/barbecue.nvim",
	name = "barbecue",
	opts = {
		attach_navic = false,
		theme = {
			normal = { link = "BarbecueNormal" },
			ellipsis = { link = "BarbecueEllipsis" },
			separator = { link = "BarbecueSeparator" },
			basename = { link = "BarbecueBasename" },
			dirname = { link = "BarbecueDirname" },
		},
	},

	cmd = { "Barbecue" },
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons",
	},
}
