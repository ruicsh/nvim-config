-- https://github.com/tpope/vim-rsi

local map = vim.keymap.set

-- Insert mode mappings
map("i", "<c-a>", "<c-o>^") -- Go to beginning of line.
map("i", "<c-c><c-a>", "<c-a>") -- Access Vim's built-in |i_CTRL-A| or |c_CTRL-A|.

-- Go backwards one character. On a blank line, kill it and go back to the previous line.
map("i", "<c-b>", function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	if line:match("^%s*$") and col > #line then
		return "0<c-d><esc>kJs"
	else
		return "<left>"
	end
end, { expr = true })

-- Delete character in front of cursor. Falls back to |i_CTRL-D| or |c_CTRL-D| at the end of the line.
map("i", "<c-d>", function()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	local line = vim.api.nvim_get_current_line()
	return col > #line and "<c-d>" or "<del>"
end, { expr = true })

-- Go to end of line.  Falls back to |i_CTRL-E| if already at the end of the line.
-- (|c_CTRL-E| already goes to end of line, so it is not mapped.)
map("i", "<c-e>", function()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	local line = vim.api.nvim_get_current_line()
	return (col > #line or vim.fn.pumvisible() == 1) and "<c-e>" or "<end>"
end, { expr = true })

-- Move forward one character.  Falls back to |i_CTRL-F| or |c_CTRL-F| at the end of the line.
map("i", "<c-f>", function()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	local line = vim.api.nvim_get_current_line()
	return col > #line and "<c-f>" or "<right>"
end, { expr = true })

-- Command mode mappings
map("c", "<c-a>", "<home>")
map("c", "<c-x><c-a>", "<c-a>")
map("c", "<c-b>", "<left>")
map("c", "<c-d>", function()
	local pos = vim.fn.getcmdpos()
	local line = vim.fn.getcmdline()
	return pos > #line and "<c-d>" or "<del>"
end, { expr = true })
map("c", "<c-f>", function()
	local pos = vim.fn.getcmdpos()
	local line = vim.fn.getcmdline()
	return pos > #line and vim.o.cedit or "<right>"
end, { expr = true })
