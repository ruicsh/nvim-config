-- Session management.
-- https://github.com/folke/persistence.nvim

return {
	"folke/persistence.nvim",
	opts = {
		branch = true,
	},

	event = { "BufReadPre" },
}
