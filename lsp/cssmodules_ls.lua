-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/cssmodules_ls.lua

return {
	cmd = {
		"cssmodules-language-server",
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_markers = {
		"package.json",
	},
}
