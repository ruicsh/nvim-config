-- Terminal windows.
-- https://github.com/tjdevries/config.nvim/blob/master/plugin/terminal.lua

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/terminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	pattern = "term://*",
	callback = function()
		if vim.opt.buftype:get() == "terminal" then
			local o = vim.opt_local
			o.scrolloff = 0 -- Don't scroll when at the top or bottom of the terminal buffer
			o.filetype = "terminal"
			o.hidden = true -- Hide the terminal buffer when switching to another buffer
			o.buflisted = false -- Don't show terminal buffers in the buffer list
			o.signcolumn = "yes" -- Show sign column (add some padding)
			vim.cmd.startinsert() -- Start in insert mode
		end
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = "term://*",
	callback = function()
		if vim.b.is_vimtest_terminal then
			return
		end

		vim.cmd.startinsert()
	end,
})
