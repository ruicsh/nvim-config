-- Statuscolumn format.
-- https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md

return {
	"folke/snacks.nvim",
	opts = {
		statuscolumn = {
			left = { "sign", "git" },
			right = { "fold" },
		},
	},

	event = "BufRead",
}
