-- Jump to last location when opening a file
-- https://vim.fandom.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/last_location_on_file", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd('normal! g`"zz')
		end
	end,
})
