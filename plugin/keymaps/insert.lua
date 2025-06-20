-- Insert mode keymaps `:h insert-index`

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("i", lhs, rhs, options)
end

-- Always exit insert mode when saving.
local save_keys = { "<c-s>", "<d-s>" }
for _, key in ipairs(save_keys) do
	k(key, "<cmd>silent! update<cr><esc>", { desc = "Save", unique = false })
end

-- Don't auto-indent when pasting (`:h i_CTRL-R_CTRL-O`)
k("<c-r>", "<c-r><c-o>")
k("<c-v>", "<c-r><c-o>+")

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
k("<m-bs>", "<c-w>")
k("<m-d>", "<c-o>dw")

-- Insert previously insert text (`:h i_CTRL-A`)
k("<c-x><c-a>", "<c-a>")

-- Make undo work word by word (`:h i_CTRL-G_u`)
local undo_keys = { "<space>", ",", ".", "!", "?", ">", ")", "]", "}" }
for _, key in ipairs(undo_keys) do
	k(key, key .. "<c-g>u")
end
