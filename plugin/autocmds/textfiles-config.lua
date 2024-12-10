-- Custom settings when opening text files.
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local group = vim.api.nvim_create_augroup("ruicsh/textfiles_config", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "text", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})
