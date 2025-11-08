-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/pyright.lua

return {
	cmd = {
		"pyright-langserver",
		"--stdio",
	},
	filetypes = {
		"python",
	},
	root_markers = {
		".git",
		"Pipfile",
		"pyproject.toml",
		"pyrightconfig.json",
		"requirements.txt",
		"setup.cfg",
		"setup.py",
	},
	-- https://microsoft.github.io/pyright/#/settings?id=pyright-settings
	settings = {
		pyright = {
			strict = true,
		},
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},

	single_file_support = true,
}
