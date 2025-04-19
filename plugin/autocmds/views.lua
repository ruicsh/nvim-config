local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/views", { clear = true })

-- Save view when leaving a buffer
vim.api.nvim_create_autocmd("BufWinLeave", {
	group = augroup,
	callback = function()
		vim.cmd.mkview({ mods = { emsg_silent = true } })
	end,
})

-- Load view when entering a buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = augroup,
	callback = function()
		vim.cmd.loadview({ mods = { emsg_silent = true } })
	end,
})
