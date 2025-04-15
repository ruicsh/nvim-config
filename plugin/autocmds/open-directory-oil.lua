-- If neovim is opened with a directory as argument open Oil

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/open-directory-oil", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = function()
		local first_arg = vim.v.argv[3]
		if first_arg and vim.fn.isdirectory(first_arg) == 1 then
			vim.cmd.Oil(first_arg)
		end
	end,
})
