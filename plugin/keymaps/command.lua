local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("c", lhs, rhs, options)
end

-- bash shortcuts
-- https://github.com/tpope/vim-rsi

-- Jump back/forward one character.
k("<c-b>", "<left>")
k("<c-f>", "<right>")

-- Jump word back/forward
k("<m-b>", "<s-left>")
k("<m-f>", "<s-right>")

-- Jump to line begin/end
k("<c-a>", "<home>")
k("<c-e>", "<end>", { unique = false })

-- Delete character back/forward
k("<bs>", "<bs>")
k("<c-d>", "<del>")

-- Delete back one word.
k("<m-bs>", "<c-s-w>")

-- Filter the command line history. `Pratical Vim, pp 69`
k("<c-n>", "<down>")
k("<c-p>", "<up>")
