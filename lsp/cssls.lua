-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/cssls.lua

return {
	cmd = {
		"vscode-css-language-server",
		"--stdio",
	},
	filetypes = {
		"css",
		"scss",
		"less",
	},
	root_markers = {
		"package.json",
		".git",
	},
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},

	init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
	single_file_support = true,
}
