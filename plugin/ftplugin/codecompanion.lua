-- CodeCompanion Chat buffer.

local augroup = vim.api.nvim_create_augroup("ruicsh/ft/codecompanion", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "codecompanion",
	callback = function()
		vim.opt_local.shiftwidth = 2
	end,
})
