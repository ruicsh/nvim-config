-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/pyright.lua

return {
	cmd = {
		"pyright-langserver",
		"--stdio",
	},
	filetypes = {
		"python",
	},
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
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
