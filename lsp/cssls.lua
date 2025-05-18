-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/cssls.lua

return {
	cmd = {
		"vscode-css-language-server",
		"--stdio",
	},
	filetypes = {
		"css",
		"less",
		"scss",
	},
	root_markers = {
		".git",
		"package.json",
	},
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},

	init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
	single_file_support = true,
}
