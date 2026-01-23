-- Add typescript to tsx files

local group = vim.api.nvim_create_augroup("ruicsh/ftdetect/typescriptreact", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = group,
	pattern = "*.tsx",
	callback = function()
		vim.bo.filetype = "typescriptreact.typescript"
	end,
})
