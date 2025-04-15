-- Disable newline comments
-- https://github.com/scottmckendry/Windots/blob/main/nvim/lua/core/autocmds.lua

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/disable-new-line-comments", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})
