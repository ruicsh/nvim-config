vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("ruicsh/BufReadPost", { clear = true }),
	callback = function(args)
		-- Go to last location when opening a file.
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd('normal! g`"zz')
		end
	end,
})
