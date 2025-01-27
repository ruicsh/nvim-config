-- On WinLeave, save the buffer (and format it) if it is modified.

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/save-on-win-leave", { clear = true })

local ignore_ft = { "", "oil", "fugitive", "gitcommit", "snacks_picker_input", "help", "qf", "terminal" }

vim.api.nvim_create_autocmd("WinLeave", {
	group = augroup,
	callback = function(event)
		local ft = vim.bo.filetype

		if vim.tbl_contains(ignore_ft, ft) then
			return
		end

		if vim.bo.modified then
			require("conform").format({ bufnr = event.buf })
			vim.cmd("write")
		end
	end,
})
