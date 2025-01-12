-- Terminal windows.
-- https://github.com/tjdevries/config.nvim/blob/master/plugin/terminal.lua

local group = vim.api.nvim_create_augroup("ruicsh/terminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
	group = group,
	pattern = "term://*",
	callback = function()
		if vim.opt.buftype:get() == "terminal" then
			local set = vim.opt_local
			set.number = false -- Don't show numbers
			set.relativenumber = false -- Don't show relativenumbers
			set.scrolloff = 0 -- Don't scroll when at the top or bottom of the terminal buffer
			vim.opt.filetype = "terminal"

			vim.cmd.startinsert() -- Start in insert mode
		end
	end,
})
