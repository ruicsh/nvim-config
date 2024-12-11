-- CSV files.

local group = vim.api.nvim_create_augroup("ruicsh/ft/csv", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "qf",
	callback = function()
		require("csvview").enable()

		vim.opt_local.mousescroll = "ver:3,hor:6" -- Enable horizontal scroll
	end,
})
