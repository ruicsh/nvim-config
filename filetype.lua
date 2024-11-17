vim.filetype.add({
	extension = {
		conf = "config",
		env = "config",
	},
	filename = {
		[".env"] = "config",
		["tsconfig.json"] = "jsonc",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "config",
		["**/__snapshots__/*.ts.snap"] = "jsonc",
		["**/__snapshots__/*.js.snap"] = "jsonc",
	},
})
