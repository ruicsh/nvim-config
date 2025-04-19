local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("i", lhs, rhs, options)
end

-- bash shortcuts
-- https://github.com/tpope/vim-rsi

-- Jump back/forward one character.
k("<c-b>", "<left>")
k("<c-f>", "<right>")

-- Jump back/forward one word.
k("<m-b>", "<s-left>")
k("<m-f>", "<s-right>")

-- Delete character in front of cursor
k("<c-d>", "<del>")

-- Delete back/forward one word.
k("<m-bs>", "<c-s-w>")
k("<m-d>", "<c-o>dw")

-- Jump to biginning/end of line.
k("<c-a>", "<c-o>^")
k("<c-e>", "<c-o>$", { unique = false })
