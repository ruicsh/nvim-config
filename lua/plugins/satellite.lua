-- Scrollbar.
-- https://github.com/lewis6991/satellite.nvim

return {
	"lewis6991/satellite.nvim",
	opts = {
		current_only = true,
		winblend = 80,
	},

	event = { "BufReadPre" },
}
