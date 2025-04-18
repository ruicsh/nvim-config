-- Terminal windows.
-- https://github.com/tjdevries/config.nvim/blob/master/plugin/terminal.lua

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/terminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	pattern = "term://*",
	callback = function()
		if vim.opt.buftype:get() == "terminal" then
			local set = vim.opt_local
			set.scrolloff = 0 -- Don't scroll when at the top or bottom of the terminal buffer
			vim.opt.filetype = "terminal"
			vim.opt.hidden = true -- Hide the terminal buffer when switching to another buffer
			vim.opt.buflisted = false -- Don't show terminal buffers in the buffer list
			vim.opt.signcolumn = "yes" -- Show sign column (add some padding)
			vim.cmd.startinsert() -- Start in insert mode
		end
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = "term://*",
	callback = function()
		vim.cmd.startinsert() -- Start in insert mode
	end,
})
