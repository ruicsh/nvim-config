local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/vim-enter", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = augroup,
	callback = function()
		-- Load env vars from config
		vim.cmd("LoadEnvVars")

		-- Enable LSP servers via custom command (respects disabled env)
		vim.cmd("LspEnable")

		-- If vim was opened with files, don't open changed files
		if #vim.fn.argv() > 0 then
			return
		end

		-- Check if Lazy is open
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
			if filetype == "lazy" then
				return -- Exit the callback if Lazy is open
			end
		end
	end,
})
