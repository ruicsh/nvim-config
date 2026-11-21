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
		-- Deferred because `syntax on` re-applies the filetype afterwards.
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(bufnr) then
				vim.bo[bufnr].syntax = vim.filetype.match({ buf = bufnr }) or ""
			end
		end)

		-- mini.hipatterns scans changed lines in Lua, and its `.*...$` patterns
		-- are O(n^2) on a single huge line: it keeps scheduling passes that even
		-- `:q` waits on. Same reason rest.nvim buffers opt out in
		-- lua/plugins/mini.hipatterns.lua.
		vim.b[bufnr].minihipatterns_disable = true

		-- Treesitter folding is expensive without a parser, and the sign column
		-- would only show fold markers.
		if vim.api.nvim_win_get_buf(0) == bufnr then
			vim.wo.foldmethod = "manual"
			vim.wo.foldcolumn = "0"
		end
	end,
})
