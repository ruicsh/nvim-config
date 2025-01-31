-- Git log.

local augroup = vim.api.nvim_create_augroup("ruicsh/ft/git", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "git",
	callback = function()
		vim.wo.foldenable = true
		vim.wo.foldmethod = "syntax"
	end,
})
