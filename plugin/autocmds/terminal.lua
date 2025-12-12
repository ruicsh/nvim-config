-- Terminal buffers.

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/terminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = function()
		vim.opt_local.signcolumn = "yes" -- Shows left padding on the window
	end,
})
