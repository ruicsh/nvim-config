-- Auto resize splits when window is resized

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/auto_resize_splits", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
	group = augroup,
	callback = function()
		vim.schedule(function()
			local current_tab = vim.api.nvim_get_current_tabpage()
			vim.cmd("tabdo wincmd =") -- Resize all windows on all tabs
			vim.api.nvim_set_current_tabpage(current_tab)
		end)
	end,
})
