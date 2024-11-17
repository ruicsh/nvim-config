vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("ruicsh/User", { clear = true }),
	pattern = "TelescopePreviewerLoaded",
	callback = function()
		-- Enable line number in telescope preview.
		vim.opt_local.number = true
	end,
})
