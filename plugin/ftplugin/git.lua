-- Git log.

local group = vim.api.nvim_create_augroup("ruicsh/ft/git", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "git",
	callback = function()
		vim.wo.foldenable = true
		vim.wo.foldmethod = "syntax"
	end,
})
