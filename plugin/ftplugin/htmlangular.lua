-- Angular's component template files (*.component.html)

local augroup = vim.api.nvim_create_augroup("ruicsh/ft/htmlangular", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "htmlangular",
	callback = function()
		-- Register the htmlangular parser for the Angular language.
		vim.treesitter.language.register("angular", "htmlangular")
		vim.cmd.runtime("ftplugin/html.vim")
	end,
})
