-- Command mode keymaps

-- Setup {{{
--
local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("c", lhs, rhs, options)
end
--
-- }}}

-- Navigation {{{
--
-- Browse search matches without leaving command mode
k("<c-n>", "<c-g>") -- `:h c_ctrl-g`
k("<c-p>", "<c-t>") -- `:h c_ctrl-t`

-- Replacements for keys overridden by vim-rsi
k("<c-]>", "<c-f>") -- Open command line window `:h c_CTRL-F`
--
-- }}}

-- Editing {{{
--
k("<c-k>", "<c-\\>estrpart(getcmdline(), 0, getcmdpos()-1)<cr>") -- Delete line forward
--
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0:foldenable
