-- Search in directories.
-- https://github.com/princejoogie/dir-telescope.nvim

return {
	"https://github.com/princejoogie/dir-telescope.nvim",
	keys = {
		{ "<leader>fd", "<cmd>Telescope dir live_grep<cr>", { desc = "Telescope: [f]ind in [d]irectory" } },
	},

	event = { "VeryLazy" },
}
