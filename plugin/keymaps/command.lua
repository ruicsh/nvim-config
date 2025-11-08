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

-- Linewise navigation
k("<c-b>", "<left>") -- Jump character backward `:h c_<Left>`
k("<c-f>", "<right>") -- Jump character forward `:h c_<Right>`
k("<a-b>", "<s-left>") -- Jump word backward `:h c_<S-Left>`
k("<a-f>", "<s-right>") -- Jump word forward `:h c_<S-Right>`
k("<c-a>", "<c-b>") -- Jump to line start `:h c_ctrl-b`
k("<c-e>", "<end>") -- Jump to line end `:h c_end`

-- Replacements for keys overridden by above mappings
k("<c-x><c-a>", "<c-a>") -- Insert all names that match the pattern `:h c_CTRL-A`
k("<c-]>", "<c-f>") -- Open command line window `:h c_CTRL-F`
--
-- }}}

-- Editing {{{
--
k("<c-d>", function() -- Delete character forward `:h c_<Del>`
	local pos = vim.fn.getcmdpos()
	local line = vim.fn.getcmdline()
	if pos > #line then
		return "<c-d>"
	else
		return "<del>"
	end
end, { expr = true })
k("<a-d>", "<s-right><c-w>") -- Delete word forward
k("<c-u>", function() -- Delete line backward `:h c_CTRL-U`
	local pos = vim.fn.getcmdpos()
	if pos > 1 then
		vim.fn.setreg("-", string.sub(vim.fn.getcmdline(), 1, pos - 2))
	end
	return "<c-u>"
end, { expr = true })
k("<c-k>", "<c-\\>estrpart(getcmdline(), 0, getcmdpos()-1)<cr>") -- Delete line forward
--
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0:foldenable
