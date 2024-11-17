vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("ruicsh/BufEnter", { clear = true }),
	callback = function()
		-- Do not auto-wrap comments.
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})
