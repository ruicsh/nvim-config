-- Auto disable hlsearch when cursor moves and there is no exact match
-- https://www.reddit.com/r/neovim/comments/1ct2w2h/comment/l4bgvn1/?utm_source=share&utm_medium=web3x&utm_name=web3xcss

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/auto-hlsearch", { clear = true })

vim.api.nvim_create_autocmd("CursorMoved", {
	group = augroup,
	callback = function()
		if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
			vim.schedule(function()
				vim.search.clear_search_count()
				vim.cmd.nohlsearch()
			end)
		end
	end,
})
