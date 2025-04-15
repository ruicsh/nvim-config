-- Keep cursor position on yank.
-- https://nanotipsforvim.prose.sh/sticky-yank

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/yank-keep-cursor-position", { clear = true })

local cursorPreYank
vim.keymap.set({ "n", "o", "v" }, "y", function()
	cursorPreYank = vim.api.nvim_win_get_cursor(0)
	return "y"
end, { expr = true, unique = true })

vim.keymap.set("n", "Y", function()
	cursorPreYank = vim.api.nvim_win_get_cursor(0)
	return "yg_" -- Don't include whitespaces at the end
end, { expr = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		if vim.v.event.operator == "y" and cursorPreYank then
			local bufnr = vim.api.nvim_get_current_buf()
			local line_count = vim.api.nvim_buf_line_count(bufnr)
			-- Check if cursor position is valid before setting it
			if cursorPreYank[1] <= line_count then
				vim.api.nvim_win_set_cursor(0, cursorPreYank)
			end
		end
	end,
})
