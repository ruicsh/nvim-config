-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/css_variables.lua

return {
	cmd = {
		"css-variables-language-server",
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
	-- Same as inlined defaults that don't seem to work without hardcoding them in the lua config
	-- https://github.com/vunguyentuan/vscode-css-variables/blob/763a564df763f17aceb5f3d6070e0b444a2f47ff/packages/css-variables-language-server/src/CSSVariableManager.ts#L31-L50
	settings = {
		cssVariables = {
			lookupFiles = { "**/*.less", "**/*.scss", "**/*.sass", "**/*.css" },
			blacklistFolders = {
				"**/.cache",
				"**/.DS_Store",
				"**/.git",
				"**/.hg",
				"**/.next",
				"**/.svn",
				"**/bower_components",
				"**/CVS",
				"**/dist",
				"**/node_modules",
				"**/tests",
				"**/tmp",
			},
		},
	},
}
