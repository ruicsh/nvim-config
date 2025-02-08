-- Indent guides.
-- https://github.com/folke/snacks.nvim/blob/main/docs/indent.md

return {
	"folke/snacks.nvim",
	opts = {
		indent = {
			animate = {
				enabled = false,
			},
			scope = {
				only_current = true,
			},
		},
	},

	event = { "BufReadPre", "BufNewFile" },
}
