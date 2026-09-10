-- Set default filetype to markdown for new, undetected, or unnamed buffers.

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/default-filetype", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
	group = augroup,
	callback = function()
		if vim.bo.filetype == "" then
			vim.bo.filetype = "markdown"
		end
	end,
})