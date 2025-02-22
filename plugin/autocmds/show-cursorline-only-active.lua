-- Show cursor line only in active window.
-- https://github.com/folke/dot/blob/master/nvim/lua/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/show-cursorline-only-active", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	group = augroup,
	callback = function()
		if vim.wo.previewwindow then
			return
		end

		if vim.w.auto_cursorline then
			vim.wo.cursorline = true
			vim.w.auto_cursorline = false
		end
	end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	group = augroup,
	callback = function()
		if vim.wo.previewwindow then
			return
		end

		if vim.wo.cursorline then
			vim.w.auto_cursorline = true
			vim.wo.cursorline = false
		end
	end,
})
