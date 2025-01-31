-- SCSS files.

local augroup = vim.api.nvim_create_augroup("ruicsh/ft/scss", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "scss",
	callback = function()
		-- Handle kebab-case as a word
		-- CSS files have this setup by default
		-- https://nanotipsforvim.prose.sh/word-boundaries-and-kebab-case-variables
		vim.opt_local.iskeyword:append("-")
	end,
})
