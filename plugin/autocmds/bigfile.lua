-- Restore syntax in huge files marked as `bigfile`
-- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/autocmds.lua

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/bigfile", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "bigfile",
	callback = function(args)
		local bufnr = args.buf

		-- `bigfile` has no syntax file and the filetype pattern in filetype.lua
		-- skips marked buffers, so this resolves the underlying filetype.
		vim.bo[bufnr].syntax = vim.filetype.match({ buf = bufnr }) or ""

		-- Treesitter folding is expensive without a parser, and the sign column
		-- would only show fold markers.
		if vim.api.nvim_win_get_buf(0) == bufnr then
			vim.wo.foldmethod = "manual"
			vim.wo.foldcolumn = "0"
		end
	end,
})
