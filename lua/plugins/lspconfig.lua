-- Native LSP configuration
-- https://github.com/neovim/nvim-lspconfig

return {
	"neovim/nvim-lspconfig",
	enabled = not os.getenv("NVIM_GIT_DIFF"),
	lazy = false,
}
