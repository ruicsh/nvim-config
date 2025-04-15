-- Keep cursor position on yank.
-- https://nanotipsforvim.prose.sh/sticky-yank
-- https://github.com/chrisgrieser/nanotipsforvim-blog/issues/1

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/yank-keep-cursor-position", { clear = true })

vim.keymap.set({ "n", "o", "v" }, "y", function()
	vim.b.cursor_per_yank = vim.api.nvim_win_get_cursor(0)
	return "y"
end, { expr = true, unique = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		if vim.v.event.operator == "y" and vim.b.cursor_per_yank then
			local bufnr = vim.api.nvim_get_current_buf()
			local line_count = vim.api.nvim_buf_line_count(bufnr)
			-- Check if cursor position is valid before setting it
			if vim.b.cursor_per_yank[1] <= line_count then
				vim.api.nvim_win_set_cursor(0, vim.b.cursor_per_yank)
			end
			vim.b.cursor_per_yank = nil
		end
	end,
})
