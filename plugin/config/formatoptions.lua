-- Remove default format formatoptions

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/formatoptions", { clear = true })

vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
	group = augroup,
	callback = function()
		vim.opt_local.formatoptions:remove("r") -- Do not continue comments when pressing <Enter> in Insert mode. `:h fo-r`
		vim.opt_local.formatoptions:remove("o") -- Do not continue comments when pressing 'o' or 'O' in Normal mode. `:h fo-o`
	end,
})
