local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/vim-enter", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = function()
		-- Load env vars from config
		vim.cmd("LoadEnvVars")
	end,
})
