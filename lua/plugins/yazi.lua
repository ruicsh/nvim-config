-- yazi terminal file manager
-- https://github.com/mikavilpas/yazi.nvim

return {
	"mikavilpas/yazi.nvim",
	keys = {
		{ "<leader>-", mode = { "n", "v" }, "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
		{ "<leader>_", "<cmd>Yazi cwd<cr>", desc = "Open yazi at the current working directory" },
	},
	opts = {
		open_for_directories = true,
		keymaps = {
			show_help = "<f1>",
			open_file_in_vertical_split = "<c-w>v",
			open_file_in_horizontal_split = "<c-w>s",
			open_and_pick_window = "<c-w>p",
		},
	},
	init = function()
		vim.g.loaded_netrwPlugin = 1
	end,

	version = "*",
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
}
