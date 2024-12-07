-- Don't show line numbers on terminal windows
-- Start on insert mode when opening a terminal window
-- https://github.com/tjdevries/config.nvim/blob/master/plugin/terminal.lua

local group = vim.api.nvim_create_augroup("ruicsh/terminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
	group = group,
	callback = function()
		if vim.opt.buftype:get() == "terminal" then
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
			vim.opt_local.scrolloff = 0
			vim.cmd("startinsert")
		end
	end,
})
