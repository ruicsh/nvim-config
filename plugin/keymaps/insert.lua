-- Insert mode keymaps `:h insert-index`

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("i", lhs, rhs, options)
end

-- Navigation {{{
--
k("<c-h>", "<left>") -- Jump character backward `:h i_<Left>`
k("<c-l>", "<right>") -- Jump character forward `:h i_<Right>`
k("<c-b>", "<s-left>") -- Jump word backward `:h i_<S-Left>`
k("<c-w>", "<s-right>", { unique = false }) -- Jump word forward `:h i_<S-Right>`
k("<c-s-h>", "<home>") -- Jump to line start `:h i_<Home>`
k("<c-s-l>", "<end>") -- Jump to line end `:h i_<End>`
-- }}}

-- Editing {{{
--
-- Delete
k("<a-h>", "<bs>") -- Delete character backward (`:h i_<BS>`)
k("<a-l>", "<c-o>dl") -- Delete character forward
k("<a-b>", "<c-w>") -- Delete word backward (`:h i_CTRL-W`)
k("<a-w>", "<c-o>de") -- Delete word forward
k("<a-s-h>", "<c-u>") -- Delete line backward (`:h i_CTRL-U`)
k("<a-s-l>", "<c-o>dg_") -- Delete line forward
k("<a-d><a-d>", "<c-o>dd") -- Delete whole line
-- <c-t> Insert one shiftwidth of indentation (`:h i_CTRL-T`)
-- <c-d> Delete one shiftwidth of indentation (`:h i_CTRL-D`)

-- <c-r><c-o> Don't auto-indent when pasting (`:h i_CTRL-R_CTRL-O`)

-- Paste from clipboard without auto-indentation (`:h i_CTRL-r_CTRL-O`)
k("<c-v>", "<c-r><c-o>+")

-- Move current line up/down
k("<a-up>", "<c-o>:move .-2<cr>", { desc = "Move current line up" }) -- `:h :move`
k("<a-down>", "<c-o>:move .+1<cr>", { desc = "Move current line down" }) -- `:h :move`

-- Make undo work word by word (`:h i_CTRL-G_u`)
local undo_keys = { "<space>", ";", ",", ".", "!", "?", ">", ")", "]", "}" }
for _, key in ipairs(undo_keys) do
	k(key, key .. "<c-g>u")
end
-- }}}

-- Miscellaneous {{{
--
-- Always exit insert mode when saving.
local save_keys = { "<c-s>", "<d-s>" }
for _, key in ipairs(save_keys) do
	k(key, "<cmd>silent! update | redraw<cr><esc>", { desc = "Save", unique = false })
end
-- }}}
-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0:foldenable
