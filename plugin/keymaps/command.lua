local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("c", lhs, rhs, options)
end

-- https://github.com/tpope/vim-rsi

-- Go to the beginning of the command line
k("<c-a>", "<home>")

-- Access Vim's built-in |c_CTRL-A|.
k("<c-x><c-a>", "<c-a>")

-- Go backwards one character.
k("<c-b>", "<left>")

-- Delete the character under the cursor.
k("<c-d>", function()
	local pos = vim.fn.getcmdpos()
	local line = vim.fn.getcmdline()
	return pos > #line and "<c-d>" or "<del>"
end, { expr = true })

-- Move forward one character.
k("<c-f>", function()
	local pos = vim.fn.getcmdpos()
	local line = vim.fn.getcmdline()
	return pos > #line and vim.o.cedit or "<right>"
end, { expr = true })
