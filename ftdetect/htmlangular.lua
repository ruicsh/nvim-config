-- Detect and set the proper file type for Angular Template files.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("ruicsh/htmlangular", { clear = true }),
	pattern = "*.component.html",
	callback = function()
		vim.bo.filetype = "htmlangular"
	end,
})
