-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/harper_ls.lua

return {
	cmd = {
		"harper-ls",
		"--stdio",
	},
	root_markers = {
		".git",
	},
	-- https://writewithharper.com/docs/integrations/language-server#Configuration
	settings = {
		["harper-ls"] = {
			diagnosticSeverity = "hint",
			userDictPath = vim.o.spellfile,
			markdown = {
				IgnoreLinkTitle = true,
			},
			linters = {
				sentenceCapitalization = true,
			},
			isolateEnglish = true,
			dialect = "British",
		},
	},

	single_file_support = true,
}
