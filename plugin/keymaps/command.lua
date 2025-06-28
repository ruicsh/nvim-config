-- Command mode keymaps

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("c", lhs, rhs, options)
end

-- Use <c-f> to open the commend line window and edit the command `:h c_CTRL-f`

-- Filter the command line history. `Pratical Vim, pp 69`
k("<c-n>", "<down>") -- `:h c_Down`
k("<c-p>", "<up>") -- `:h c_Up`
