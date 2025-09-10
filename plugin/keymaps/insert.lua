-- Insert mode keymaps `:h insert-index`

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("i", lhs, rhs, options)
end

-- Navigation {{{
--
k("<c-b>", "<left>") -- Jump character backward `:h i_<Left>`
k("<c-f>", "<right>") -- Jump character forward `:h i_<Right>`
k("<a-b>", "<s-left>") -- Jump word backward `:h i_<S-Left>`
k("<a-f>", "<s-right>", { unique = false }) -- Jump word forward `:h i_<S-Right>`
k("<c-a>", "<c-o>^") -- Jump to line start `:h ^`
k("<c-e>", "<c-o>$") -- Jump to line end `:h $`
--
-- }}}

-- Editing {{{
--
-- Delete
k("<c-d>", "<c-o>dl") -- Delete character forward
k("<c-w>", "<c-g>u<c-w>", { unique = false }) -- Delete word backward (`:h i_CTRL-W`)
k("<a-d>", "<c-g>u<c-o>diw") -- Delete word forward
k("<c-u>", "<c-g>u<c-u>", { unique = false }) -- Delete line backward (`:h i_CTRL-U`)
k("<c-k>", "<c-g>u<c-o>d$", { unique = false }) -- Delete line forward
k("<a-d><a-d>", "<c-g>u<c-o>dd") -- Delete whole line

-- <c-t> Insert one shiftwidth of indentation (`:h i_CTRL-T`)
-- <c-d> Delete one shiftwidth of indentation (`:h i_CTRL-D`)
-- <c-r><c-o> Don't auto-indent when pasting (`:h i_CTRL-R_CTRL-O`)

-- Paste from clipboard without auto-indentation (`:h i_CTRL-r_CTRL-O`)
k("<c-v>", "<c-r><c-o>+")

-- Move current line up/down
k("<a-up>", "<esc>:move .-2<cr>==gi", { desc = "Move current line up" }) -- `:h :move`
k("<a-down>", "<esc>:move .+1<cr>==gi", { desc = "Move current line down" }) -- `:h :move`

-- Make undo work word by word (`:h i_CTRL-G_u`)
local undo_keys = { "<space>", ";", ",", ".", "!", "?", ">", ")", "]", "}" }
for _, key in ipairs(undo_keys) do
	k(key, key .. "<c-g>u")
end
--
-- }}}

-- Miscellaneous {{{
--
-- Always exit insert mode when saving.
local save_keys = { "<c-s>", "<d-s>" }
for _, key in ipairs(save_keys) do
	k(key, "<cmd>silent! update | redraw<cr><esc>", { desc = "Save", unique = false })
end
--
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0:foldenable
