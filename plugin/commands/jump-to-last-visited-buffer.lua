-- Toggle to last buffer, switch to Oil if last

local last_buf_ft = nil

-- Store the filetype when leaving a buffer
vim.api.nvim_create_autocmd("BufLeave", {
	callback = function()
		last_buf_ft = vim.bo.filetype
	end,
})

vim.api.nvim_create_user_command("JumpToLastVisitedBuffer", function()
	if last_buf_ft == "oil" then
		vim.api.nvim_command("Oil")
		return
	end

	vim.api.nvim_command("silent! buffer #")
end, {})
