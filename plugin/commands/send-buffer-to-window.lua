-- Send buffer to window command

vim.api.nvim_create_user_command("SendBufferToWindow", function(opts)
	local current_buf = vim.api.nvim_get_current_buf()
	local current_win = vim.api.nvim_get_current_win()

	-- Display the last used buffer in the current window
	vim.api.nvim_set_current_win(current_win)
	vim.cmd("buffer #")

	-- Move to the window specified by the argument
	vim.cmd("wincmd " .. opts.args)
	local adjacent_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(adjacent_win, current_buf)
end, {
	nargs = "?", -- Allow optional argument
	complete = function()
		return { "h", "j", "k", "l" }
	end,
})
