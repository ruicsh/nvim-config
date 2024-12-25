-- Maximize/restore windows
-- https://github.com/anuvyklack/windows.nvim

return {
	"anuvyklack/windows.nvim",
	keys = function()
		local mappings = {
			{ "<c-w>m", ":WindowsMaximize<cr>", "Maximize", { mode = { "n", "x", "i" } } },
		}
		return vim.fn.getlazykeysconf(mappings, "Windows")
	end,
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
