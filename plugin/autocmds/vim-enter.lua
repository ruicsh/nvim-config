-- Loaded on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("ruicsh/VimEnter", { clear = true }),
	callback = function()
		-- If neovim is opened with a directory as argument open oil-filemanager.
		local first_arg = vim.v.argv[3]
		if first_arg and vim.fn.isdirectory(first_arg) == 1 then
			vim.cmd.Oil(first_arg)
		end
	end,
})
