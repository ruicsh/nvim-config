-- Command mode keymaps

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("c", lhs, rhs, options)
end

-- Use <c-f> to open the commend line window and edit the command `:h c_CTRL-f`

-- Filter the command line history. `Pratical Vim, pp 69`
k("<c-n>", "<down>") -- `:h c_Down`
k("<c-p>", "<up>") -- `:h c_Up`

-- Navigate within the command line
k("<c-h>", "<left>") -- Jump character backward `:h c_<Left>`
k("<c-l>", "<right>") -- Jump character forward `:h c_<Right>`
k("<c-b>", "<s-left>") -- Jump word backward `:h c_<S-Left>`
k("<c-w>", "<s-right>") -- Jump word forward `:h c_<S-Right>`
k("<c-s-h>", "<home>") -- Jump to line start `:h c_<Home>`
k("<c-s-l>", "<end>") -- Jump to line end `:h c_<End>`

-- Editing commands
k("<a-h>", "<bs>") -- Delete character backward (`:h c_<BS>`)
k("<a-l>", "<del>") -- Delete character forward (`:h c_<Del>`)
k("<a-b>", "<c-w>") -- Delete word backward (`:h c_CTRL-W`)
k("<a-s-h>", "<c-u>") -- Delete line backward (`:h c_CTRL-U`)
