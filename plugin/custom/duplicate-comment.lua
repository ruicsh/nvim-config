-- Duplicate and comment
-- https://www.reddit.com/r/neovim/comments/1k4efz8/comment/mola3k0/

local function duplicate_and_comment_lines()
	local start_line, end_line = vim.api.nvim_buf_get_mark(0, "[")[1], vim.api.nvim_buf_get_mark(0, "]")[1]

	-- NOTE: `nvim_buf_get_mark()` is 1-indexed, but `nvim_buf_get_lines()` is 0-indexed. Adjust accordingly.
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	-- Store cursor position because it might move when commenting out the lines.
	local cursor = vim.api.nvim_win_get_cursor(0)

	-- Comment out the selection using the builtin "gc" operator.
	vim.cmd.normal({ "gcc", range = { start_line, end_line } })

	-- Append a duplicate of the selected lines to the end of selection.
	vim.api.nvim_buf_set_lines(0, end_line, end_line, false, lines)

	-- Move cursor to the start of the duplicate lines.
	vim.api.nvim_win_set_cursor(0, { end_line + 1, cursor[2] })
end

_G.duplicate_and_comment_lines = duplicate_and_comment_lines

vim.keymap.set({ "n", "x" }, "yc", function()
	vim.opt.operatorfunc = "v:lua.duplicate_and_comment_lines"
	return "g@"
end, { expr = true, desc = "Duplicate selection and comment out the first instance" })

vim.keymap.set("n", "ycc", function()
	vim.opt.operatorfunc = "v:lua.duplicate_and_comment_lines"
	return "g@_"
end, { expr = true, desc = "Duplicate [count] lines and comment out the first instance" })
