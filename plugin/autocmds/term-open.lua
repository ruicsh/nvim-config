vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("ruicsh/term_open", { clear = true }),
	callback = function()
		if vim.opt.buftype:get() == "terminal" then
			-- Don't show line numbers on terminal.
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
			-- Start on insert mode.
			vim.cmd("startinsert")
		end
	end,
})
