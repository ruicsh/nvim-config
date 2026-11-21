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
		-- Mark huge files as `bigfile` so treesitter, LSP, and completion stay off.
		-- Skipped once the buffer is already marked, so `vim.filetype.match()` can
		-- still recover the real filetype afterwards (see plugin/autocmds/bigfile.lua).
		[".*"] = function(path, bufnr)
			if vim.bo[bufnr].filetype ~= "bigfile" and vim.fn.getfsize(path) > 500 * 1024 then
				return "bigfile"
			end
		end,
	},
})
