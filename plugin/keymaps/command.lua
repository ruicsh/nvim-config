-- Command mode keymaps

-- Setup {{{
--
local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("c", lhs, rhs, options)
end
--
-- }}}

-- Search {{{
--
-- Browse search matches without leaving command mode
k("<c-n>", "<c-g>") -- `:h c_ctrl-g`
k("<c-p>", "<c-t>") -- `:h c_ctrl-t`

--
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0:foldenable
