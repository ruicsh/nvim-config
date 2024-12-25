-- SCSS files.

local group = vim.api.nvim_create_augroup("ruicsh/ft/scss", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "scss",
	callback = function()
		-- Handle kebab-case as a word
		-- CSS files have this setup by default
		-- https://nanotipsforvim.prose.sh/word-boundaries-and-kebab-case-variables
		vim.opt_local.iskeyword:append("-")
	end,
})
