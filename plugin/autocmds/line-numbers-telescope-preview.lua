-- Enable line number in telescope preview.

local group = vim.api.nvim_create_augroup("ruicsh/line_numbers_telescope_preview", { clear = true })

vim.api.nvim_create_autocmd("User", {
	group = group,
	pattern = "TelescopePreviewerLoaded",
	callback = function()
		vim.opt_local.number = true
	end,
})
