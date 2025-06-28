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

-- Jump character back/forward
k("<c-b>", "<left>")
k("<c-f>", "<right>")

-- <c-w> Delete word before cursor (`:h i_CTRL-W`)
-- <c-u> Delete all text before cursor (`:h i_CTRL-U`)
-- <c-a> Insert previously insert text (`:h i_CTRL-A`)
-- <c-r><c-o> Don't auto-indent when pasting (`:h i_CTRL-R_CTRL-O`)
-- <c-t> Insert one shiftwidth of indentation (`:h i_CTRL-T`)
-- <c-d> Remove one shiftwidth of indentation (`:h i_CTRL-D`)

-- Make undo work word by word (`:h i_CTRL-G_u`)
local undo_keys = { "<space>", ",", ".", "!", "?", ">", ")", "]", "}" }
for _, key in ipairs(undo_keys) do
	k(key, key .. "<c-g>u")
end
