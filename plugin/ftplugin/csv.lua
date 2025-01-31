-- CSV files.

local augroup = vim.api.nvim_create_augroup("ruicsh/ft/csv", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "csv",
	callback = function()
		require("csvview").enable()

		vim.opt_local.mousescroll = "ver:3,hor:6" -- Enable horizontal scroll
	end,
})
