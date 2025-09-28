-- Terminal mode keymaps

-- Setup {{{
--
local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("t", lhs, rhs, options)
end
--
-- }}}

-- Toggle terminal {{{
--
-- Enter normal mode
k("<c-n>", "<c-bslash><c-n>", { desc = "Enter normal mode" }) -- :h t_CTRL-\_CTRL-N

-- Better window navigation
for _, key in ipairs({ "h", "j", "k", "l", "<c-w>", "q" }) do
	k("<c-w>" .. key, "<c-\\><c-n><c-w>" .. key)
end

-- Toggle terminal buffer (close as we are in terminal mode)
k("<c-t>", function()
	vim.cmd("ToggleTerminal")
end, { desc = "Toggle terminal" })
--
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0:foldenable
