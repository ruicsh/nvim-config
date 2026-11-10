local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/cmdline", { clear = true })

local timer_id = nil

local function stop_timer()
	if timer_id then
		vim.fn.timer_stop(timer_id)
		timer_id = nil
	end
end

-- Clean-up command line after use
-- https://github.com/mcauley-penney/nvim/blob/main/lua/aucmd/init.lua
local function cleanup_after_use()
	stop_timer()
	timer_id = vim.fn.timer_start(3000, function()
		timer_id = nil
		-- Clears the message line without invoking a command-line `:echo`
		vim.api.nvim_echo({ { "" } }, false, {})
	end)
end

vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = augroup,
	callback = function()
		cleanup_after_use()
	end,
})

-- Don't clear the message area while typing a new command: it would also
-- redraw away the completion popup
vim.api.nvim_create_autocmd("CmdlineEnter", {
	group = augroup,
	callback = function()
		stop_timer()
	end,
})
