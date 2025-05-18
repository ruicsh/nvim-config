-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/emmet_language_server.lua

return {
	cmd = { "emmet-language-server", "--stdio" },
	filetypes = {
		"css",
		"eruby",
		"html",
		"htmldjango",
		"javascriptreact",
		"less",
		"pug",
		"sass",
		"scss",
		"typescriptreact",
		"htmlangular",
	},
	root_markers = { ".git" },
}
