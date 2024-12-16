-- Terminal windows.
-- https://github.com/tjdevries/config.nvim/blob/master/plugin/terminal.lua

local group = vim.api.nvim_create_augroup("ruicsh/terminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
	group = group,
	callback = function()
		if vim.opt.buftype:get() == "terminal" then
			vim.opt_local.number = false -- Don't show numbers
			vim.opt_local.relativenumber = false -- Don't show relativenumbers
			vim.cmd.startinsert() -- Start insert mode
			vim.bo.filetype = "terminal" -- Set correct filetype
		end
	end,
})

-- When switching to a terminal window, always start insert mode
vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	pattern = "term://*",
	callback = function()
		if vim.fn.mode() ~= "i" then
			vim.cmd.startinsert()
		end
	end,
})
