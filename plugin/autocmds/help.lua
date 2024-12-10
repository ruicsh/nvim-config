-- Navigation shortcuts for help files

local group = vim.api.nvim_create_augroup("ruicsh/help", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "help",
	callback = function()
		if vim.opt.buftype:get() == "help" then
			-- Better navigation.
			-- https://vim.fandom.com/wiki/Learn_to_use_help#Simplify_help_navigation
			vim.keymap.set("n", "<cr>", "<c-]>", { buffer = true })
			vim.keymap.set("n", "<bs>", "<c-T>", { buffer = true })
		end
	end,
})
