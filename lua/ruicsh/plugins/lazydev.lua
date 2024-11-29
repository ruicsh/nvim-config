-- Neovim apis lsp
-- Used for completion, annotations and signatures of Neovim APIs.
-- https://github.com/folke/lazydev.nvim

return {
	"folke/lazydev.nvim",
	opts = {
		library = {
			-- Load luvit types when the `vim.uv` word is found
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
		},
	},

	lazy = true,
	ft = "lua",
}
