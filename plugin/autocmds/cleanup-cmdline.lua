-- Cleanup command line after use
-- https://github.com/mcauley-penney/nvim/blob/main/lua/aucmd/init.lua

local group = vim.api.nvim_create_augroup("ruicsh/autocmd/clenup_cmdline", { clear = true })

vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = group,
	callback = function()
		vim.fn.timer_start(3000, function()
			print(" ")
		end)
	end,
})
