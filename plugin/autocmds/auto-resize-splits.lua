-- Auto resize splits when window is resized

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/auto_resize_splits", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
	group = augroup,
	callback = function()
		local current_tab = vim.api.nvim_get_current_tabpage()
		vim.cmd("tabdo wincmd =")
		vim.api.nvim_set_current_tabpage(current_tab)
	end,
})
