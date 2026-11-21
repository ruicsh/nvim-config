vim.filetype.add({
	extension = {
		conf = "config",
		env = "config",
		http = "http",
		zsh = "sh",
	},
	filename = {
		[".env"] = "config",
		[".eslintrc.json"] = "jsonc",
		["tsconfig.json"] = "jsonc",
		[".zshrc"] = "sh",
		[".zshenv"] = "sh",
		[".zprofile"] = "sh",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "config",
		["tsconfig.*%.json"] = "jsonc",
		[".*/%.vscode/.*%.json"] = "jsonc",
		[".*/__snapshots__/.*%.ts%.snap"] = "jsonc",
		[".*/__snapshots__/.*%.js%.snap"] = "jsonc",
	},
})
