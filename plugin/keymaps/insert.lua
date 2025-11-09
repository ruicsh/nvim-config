-- Insert mode keymaps `:h insert-index`

-- Setup {{{
--
local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("i", lhs, rhs, options)
end
--
-- }}}

-- Editing {{{
--

-- Paste from clipboard `:h i_ctrl-r`
k("<c-v>", "<c-r>+")

-- Move current line up/down
k("<a-up>", "<esc>:move .-2<cr>==gi", { desc = "Move current line up" }) -- `:h :move`
k("<a-down>", "<esc>:move .+1<cr>==gi", { desc = "Move current line down" }) -- `:h :move`

-- Make undo work word by word (`:h i_CTRL-G_u`)
local undo_keys = { "<space>", ";", ",", ".", "!", "?", ">", ")", "]", "}" }
for _, key in ipairs(undo_keys) do
	k(key, key .. "<c-g>u")
end

-- Always exit insert mode when saving.
local save_keys = { "<c-s>", "<d-s>" }
for _, key in ipairs(save_keys) do
	k(key, "<cmd>silent! update | redraw<cr><esc>", { desc = "Save", unique = false })
end
--
-- }}}

-- Miscellaneous {{{
--
k("<f1>", "<nop>", { desc = "Disable F1 help" })
--
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0:foldenable
