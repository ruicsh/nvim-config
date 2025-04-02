-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/ts_ls.lua

return {
	cmd = {
		"typescript-language-server",
		"--stdio",
	},
	filetypes = {
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = {
		"tsconfig.json",
		"jsconfig.json",
		"package.json",
		".git",
	},

	init_options = { hostInfo = "neovim" },
	single_file_support = true,
}
