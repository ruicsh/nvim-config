local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/gitcommit", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup,
	pattern = "COMMIT_EDITMSG",
	callback = function()
		vim.cmd("startinsert") -- Start in insert mode
	end,
})
