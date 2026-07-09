local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/cmdline", { clear = true })

-- Clean-up command line after use
-- https://github.com/mcauley-penney/nvim/blob/main/lua/aucmd/init.lua
local function cleanup_after_use()
	vim.fn.timer_start(3000, function()
		vim.cmd("echo ''")
	end)
end

vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = augroup,
	callback = function()
		cleanup_after_use()
	end,
})
