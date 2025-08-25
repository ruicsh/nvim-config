-- Delete buffers without disrupting window layout.
-- https://github.com/folke/snacks.nvim/blob/main/docs/bufdelete.md

return {
	"folke/snacks.nvim",
	opts = {
		bufdelete = {
			enabled = true,
		},
	},

	event = "VeryLazy",
}
