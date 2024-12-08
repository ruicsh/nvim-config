-- Disable new line comments
-- https://github.com/scottmckendry/Windots/blob/main/nvim/lua/core/autocmds.lua

local group = vim.api.nvim_create_augroup("ruicsh/disable_new_line_comments", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})
