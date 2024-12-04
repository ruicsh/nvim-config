-- Breadcrumbs
-- https://github.com/Bekaboo/dropbar.nvim

return {
	"Bekaboo/dropbar.nvim",
	config = function()
		local dropbar = require("dropbar")
		local api = require("dropbar.api")

		dropbar.setup({
			menu = {
				preview = false,
				scrollbar = {
					background = false,
				},
				keymaps = {
					["<c-]>"] = "<c-w>q", -- Global shortcut to quit.
					["h"] = "<nop>", -- Disable horizontal cursor movement.
					["l"] = "<nop>", -- Disable horizontal  cursor movement.
					["<left>"] = "<nop>", -- Disable horizontal cursor movement.
					["<right>"] = "<nop>", -- Disable horizontal cursor movement.
				},
			},
		})

		vim.keymap.set("n", "<leader>bs", api.pick, { noremap = true, silent = true })
	end,

	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
}
