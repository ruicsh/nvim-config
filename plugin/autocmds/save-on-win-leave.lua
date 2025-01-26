-- On WinLeave, save the buffer (and format it) if it is modified.

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/save-on-win-leave", { clear = true })

vim.api.nvim_create_autocmd("WinLeave", {
	group = augroup,
	callback = function(event)
		if vim.bo.modified then
			require("conform").format({ bufnr = event.buf })
			vim.cmd("write")
		end
	end,
})
