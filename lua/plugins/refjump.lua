-- Jump to reference
-- https://github.com/mawkler/refjump.nvim

return {
	"mawkler/refjump.nvim",
	opts = {
		highlights = {
			enabled = false,
		},
	},

	event = { "VeryLazy" },
	dependencies = {
		{ "mawkler/demicolon.nvim" },
	},
}
