-- Statuscolumn format.
-- https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md

return {
	"folke/snacks.nvim",
	opts = {
		statuscolumn = {
			left = { "mark", "sign" },
			right = { "fold", "git" },
		},
	},

	event = "BufRead",
}
