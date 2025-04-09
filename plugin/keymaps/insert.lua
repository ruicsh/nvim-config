local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("i", lhs, rhs, options)
end

-- https://github.com/tpope/vim-rsi

-- Go to beginning of line.
k("<c-a>", "<c-o>^")

-- Access Vim's built-in |i_CTRL-A|.
k("<c-c><c-a>", "<c-a>")

-- Go backwards one character.
k("<c-b>", function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	if line:match("^%s*$") and col > #line then
		return "0<c-d><esc>kJs"
	else
		return "<left>"
	end
end, { expr = true })

-- Delete character in front of cursor.
k("<c-d>", function()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	local line = vim.api.nvim_get_current_line()
	return col > #line and "<c-d>" or "<del>"
end, { expr = true })

-- Go to end of line.
k("<c-e>", function()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	local line = vim.api.nvim_get_current_line()
	return (col > #line or vim.fn.pumvisible() == 1) and "<c-e>" or "<end>"
end, { expr = true })

-- Move forward one character.
k("<c-f>", function()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	local line = vim.api.nvim_get_current_line()
	return col > #line and "<c-f>" or "<right>"
end, { expr = true })
