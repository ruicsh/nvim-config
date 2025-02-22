-- Scroll past the end of file just like scrolloff option.
-- simplified version of https://github.com/Aasim-A/scrollEOF.nvim
-- https://github.com/chrisgrieser/.config/blob/main/nvim/lua/config/autocmds.lua

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
			local topline = vim.fn.winsaveview().topline
			-- topline is inaccurate if it is a folded line, thus add number of folded lines
			local toplineFoldAmount = vim.fn.foldclosedend(topline) - vim.fn.foldclosed(topline)
			topline = topline + toplineFoldAmount

			vim.fn.winrestview({
				skipcol = 0, -- Without this, `gg` `G` can cause the cursor position to be shown incorrectly
				topline = topline + scrolloff - visual_distance_to_eof,
			})
		end
	end,
})

-- FIX for some reason `scrolloff` sometimes being set to `0` on new buffers
local originalScrolloff = vim.o.scrolloff
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNew" }, {
	callback = function(ctx)
		vim.defer_fn(function()
			if not vim.api.nvim_buf_is_valid(ctx.buf) or vim.bo[ctx.buf].buftype ~= "" then
				return
			end

			if vim.o.scrolloff == 0 then
				vim.o.scrolloff = originalScrolloff
			end
		end, 150)
	end,
})
