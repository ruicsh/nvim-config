-- Scroll past the end of file just like scrolloff option.
-- simplified version of https://github.com/Aasim-A/scrollEOF.nvim

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/scroll-eof", { clear = true })

vim.api.nvim_create_autocmd({ "CursorMoved", "WinScrolled" }, {
	group = augroup,
	pattern = "*",
	callback = function()
		local win_height = vim.fn.winheight(0)
		local win_cur_line = vim.fn.winline()
		local scrolloff = math.min(vim.o.scrolloff, math.floor(win_height / 2))
		local visual_distance_to_eof = win_height - win_cur_line

		if visual_distance_to_eof < scrolloff then
			local win_view = vim.fn.winsaveview()
			vim.fn.winrestview({
				skipcol = 0, -- Without this, `gg` `G` can cause the cursor position to be shown incorrectly
				topline = win_view.topline + scrolloff - visual_distance_to_eof,
			})
		end
	end,
})
