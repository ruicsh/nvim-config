-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/jsonls.lua

return {
	cmd = {
		"vscode-json-language-server",
		"--stdio",
	},
	filetypes = {
		"json",
		"jsonc",
	},
	root_markers = {
		".git",
	},
	init_options = {
		provideFormatter = true,
	},
	single_file_support = true,
}
