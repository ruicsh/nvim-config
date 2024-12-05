-- Maximize/restore windows
-- https://github.com/anuvyklack/windows.nvim

return {
	"anuvyklack/windows.nvim",
	keys = {
		{ "<c-w>m", "<cmd>WindowsMaximize<cr>", mode = { "n", "x", "i" }, silent = true },
	},
	opts = {
		animation = {
			enable = false,
		},
	},

	events = { "VeryLazy" },
	dependencies = {
		"anuvyklack/middleclass",
	},
}
