-- Terminal
-- https://github.com/akinsho/toggleterm.nvim

return {
	"akinsho/toggleterm.nvim",
	opts = {
		open_mapping = "<c-t>",
		direction = "float",
	},

	event = { "VeryLazy" },
}
