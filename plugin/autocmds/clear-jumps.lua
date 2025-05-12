-- Clear jump list when vim starts

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/clear-jumps", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = function()
		vim.cmd.clearjumps()
	end,
})
