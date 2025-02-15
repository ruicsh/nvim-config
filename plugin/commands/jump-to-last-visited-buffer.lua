-- Toggle to last buffer, switch to Oil if last

local last_buf_ft = nil

-- Store the filetype when leaving a buffer
vim.api.nvim_create_autocmd("BufLeave", {
	callback = function()
		last_buf_ft = vim.bo.filetype
	end,
})

-- Jump to the last visited buffer, if it was Oil, open it
vim.api.nvim_create_user_command("JumpToLastVisitedBuffer", function()
	if last_buf_ft == "oil" then
		vim.cmd("Oil")
		return
	end

	-- only switch to last buffer if it exists
	if vim.fn.bufexists(0) == 1 then
		vim.cmd("buffer #")
	end
end, {})
