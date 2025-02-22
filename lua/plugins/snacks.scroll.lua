-- Indent guides.
-- https://github.com/folke/snacks.nvim/blob/main/docs/scroll.md

return {
	"folke/snacks.nvim",
	opts = {
		scroll = {
			enabled = true,
			animate = {
				duration = { step = 50, total = 50 },
			},
			animate_repeat = {
				duration = { step = 50, total = 10 },
			},
		},
	},

	event = { "BufReadPre", "BufNewFile" },
}
