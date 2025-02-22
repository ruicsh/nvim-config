-- Indent guides.
-- https://github.com/folke/snacks.nvim/blob/main/docs/scroll.md

return {
	"folke/snacks.nvim",
	opts = {
		scroll = {
			enabled = true,
		},
	},

	event = { "BufReadPre", "BufNewFile" },
}
