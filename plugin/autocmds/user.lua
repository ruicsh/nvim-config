vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("ruicsh/user", { clear = true }),
	pattern = "TelescopePreviewerLoaded",
	callback = function()
		-- Enable line number in telescope preview.
		vim.opt_local.number = true
	end,
})
