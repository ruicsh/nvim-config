local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("i", lhs, rhs, options)
end

-- Always exit insert mode when saving.
local save_keys = { "<c-s>", "<d-s>" }
for _, key in ipairs(save_keys) do
	k(key, "<cmd>silent! update<cr><esc>", { desc = "Save", unique = false })
end

-- Jump character back/forward
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

-- Delete word back/forward
k("<m-bs>", "<c-o>dB")
k("<m-d>", "<c-o>dW")

-- Insert previously insert text (`:h i_CTRL-A`)
k("<c-x><c-a>", "<c-a>")

-- Always insert register content literally (`:h i_CTRL-R`)
k("<c-r>", "<c-r><c-r>")

-- Make undo work word by word.
local undo_keys = { "<space>", ",", ".", "!", "?", ">", ")", "]", "}" }
for _, key in ipairs(undo_keys) do
	k(key, key .. "<c-g>u")
end
