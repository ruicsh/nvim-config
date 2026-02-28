local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/cmdline", { clear = true })

-- Hide "hit-enter" prompt on command line on blur
-- https://www.reddit.com/r/neovim/comments/1jqk8x1/comment/ml8a9pa/
local function hide_hit_enter_on_blur()
	vim.opt.messagesopt = "hit-enter,history:1000"
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorMoved" }, {
		group = augroup,
		callback = function()
			vim.opt.messagesopt = "wait:500,history:1000"
		end,
		once = true,
	})
end

-- Clean-up command line after use
-- https://github.com/mcauley-penney/nvim/blob/main/lua/aucmd/init.lua
local function cleanup_after_use()
	vim.fn.timer_start(3000, function()
		vim.cmd("echo ''")
	end)
end

vim.api.nvim_create_autocmd("CmdlineEnter", {
	group = augroup,
	callback = function()
		hide_hit_enter_on_blur()
	end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = augroup,
	callback = function()
		cleanup_after_use()
	end,
})
