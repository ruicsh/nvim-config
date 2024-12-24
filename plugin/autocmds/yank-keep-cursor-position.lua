-- Keep cursor position on yank.
-- https://nanotipsforvim.prose.sh/sticky-yank

local group = vim.api.nvim_create_augroup("ruicsh/yank_keep_cursor_position", { clear = true })

local cursorPreYank

vim.keymap.set({ "n", "x" }, "y", function()
	cursorPreYank = vim.api.nvim_win_get_cursor(0)
	return "y"
end, { expr = true })

vim.keymap.set("n", "Y", function()
	cursorPreYank = vim.api.nvim_win_get_cursor(0)
	return "y$"
end, { expr = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		if vim.v.event.operator == "y" and cursorPreYank then
			vim.api.nvim_win_set_cursor(0, cursorPreYank)
		end
	end,
})
