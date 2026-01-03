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

-- Paste from clipboard `:h i_ctrl-r_ctrl-o`
-- Insert contents literally and don't auto-indent
k("<c-v>", "<c-r><c-o>+")

-- Make undo work word by word (`:h i_CTRL-G_u`)
local undo_keys = { "<space>", ";", ",", ".", "!", "?", ">", ")", "]", "}" }
for _, key in ipairs(undo_keys) do
	k(key, key .. "<c-g>u")
end

-- Always exit insert mode when saving.
k("<c-s>", "<cmd>silent! update | redraw<cr><esc>", { desc = "Save", unique = false })
--
-- }}}

-- Miscellaneous {{{
--

k("<c-p>", "<nop>") -- Disable native completion popup

--
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0:foldenable
