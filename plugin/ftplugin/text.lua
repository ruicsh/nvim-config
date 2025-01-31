-- Custom settings when opening text files.
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup("ruicsh/ft/text", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "text", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
	end,
})
