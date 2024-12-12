-- Restore session on startup

local group = vim.api.nvim_create_augroup("ruicsh/restore_session", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = group,
	callback = function()
		require("persistence").load()
	end,
})
