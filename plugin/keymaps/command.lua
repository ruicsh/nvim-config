local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("c", lhs, rhs, options)
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
k("<m-d>", "<s-right><del>")

-- Jump to biginning/end of line.
k("<c-a>", "<home>")

-- Filter the command line history.
-- Pratical Vim, pp 69
k("<c-n>", "<down>")
k("<c-p>", "<up>")
