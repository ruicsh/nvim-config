-- Code outline
-- https://github.com/stevearc/aerial.nvim

return {
	"stevearc/aerial.nvim",
	opts = {
		attach_mode = "global",
		highlight_on_jump = false,
		ignore = {
			filetypes = { "oil" },
		},
		layout = {
			width = 30,
		},
		on_attach = function(bufnr)
			vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
			vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
		end,
	},

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
}
