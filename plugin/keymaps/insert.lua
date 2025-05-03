local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("i", lhs, rhs, options)
end

-- Save file
local save_keys = { "<c-s>", "<d-s>" }
for _, key in ipairs(save_keys) do
	k(key, "<cmd>silent! update | redraw<cr>", { desc = "Save", unique = false })
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
k("<m-d>", "<c-o>dw")

-- Jump to beginning/end of line.
k("<c-a>", "<home>")
k("<c-e>", "<end>", { unique = false })

-- Make undo work word by word.
local undo_keys = { "<space>", ",", ".", "!", "?", ">", ")", "]", "}" }
for _, key in ipairs(undo_keys) do
	k(key, key .. "<c-g>u")
end
