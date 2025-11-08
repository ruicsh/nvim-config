-- Insert mode keymaps `:h insert-index`

-- Setup {{{
--
local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("i", lhs, rhs, options)
end
--
-- }}}

-- Navigation {{{
--
k("<c-b>", function() -- Jump character backward `:h i_<Left>`
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	if line:match("^%s*$") and col > #line then
		return "0<c-d><esc>kJs"
	else
		return "<left>"
	end
end, { expr = true })
k("<c-f>", function() -- Jump character forward `:h i_<Right>`
	local col = vim.fn.col(".")
	local line = vim.fn.getline(".")
	if col > #line then
		return "<c-f>"
	else
		return "<right>"
	end
end, { expr = true })
k("<a-b>", "<s-left>") -- Jump word backward `:h i_<S-Left>`
k("<a-f>", "<s-right>", { unique = false }) -- Jump word forward `:h i_<S-Right>`
k("<c-a>", "<c-o>^") -- Jump to line start `:h ^`
k("<c-e>", function() -- Jump to line end `:h $`
	local col = vim.fn.col(".")
	local line = vim.fn.getline(".")
	if col > #line or vim.fn.pumvisible() == 1 then
		return "<c-e>"
	else
		return "<end>"
	end
end, { expr = true })

-- Replacements for keys overridden by above mappings
k("<c-x><c-a>", "<c-a>") -- Jump to line start `:h i_CTRL-A`
--
-- }}}

-- Editing {{{
--
-- Delete
k("<c-d>", function() -- Delete character forward
	local col = vim.fn.col(".")
	local line = vim.fn.getline(".")
	if col > #line then
		return "<c-d>"
	else
		return "<del>"
	end
end, { expr = true })
k("<c-w>", "<c-g>u<c-w>", { unique = false }) -- Delete word backward (`:h i_CTRL-W`)
k("<a-d>", "<c-g>u<s-right><c-w>") -- Delete word forward
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
