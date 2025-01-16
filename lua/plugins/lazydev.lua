-- Neovim APIs LSP
-- https://github.com/folke/lazydev.nvim

return {
	"folke/lazydev.nvim",
	opts = {
		library = {
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
		},
	},

	lazy = true,
	ft = "lua",
}
