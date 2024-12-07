-- Show cursor line only in active window.
-- https://github.com/folke/dot/blob/master/nvim/lua/config/autocmds.lua

local group = vim.api.nvim_create_augroup("ruicsh/show_cursorline_only_active", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	group = group,
	callback = function()
		if vim.w.auto_cursorline then
			vim.wo.cursorline = true
			vim.w.auto_cursorline = nil
		end
	end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	group = group,
	callback = function()
		if vim.wo.cursorline then
			vim.w.auto_cursorline = true
			vim.wo.cursorline = false
		end
	end,
})
