-- Don't show line numbers on terminal windows
-- Start on insert mode when opening a terminal window

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("ruicsh/term_open", { clear = true }),
	callback = function()
		if vim.opt.buftype:get() == "terminal" then
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
			vim.cmd("startinsert")
		end
	end,
})
