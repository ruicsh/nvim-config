-- Command mode keymaps

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("c", lhs, rhs, options)
end

-- Paste from clipboard
k("<c-v>", "<c-r>+")

-- Use <c-f> to open the commend line window and edit the command `:h c_CTRL-f`

-- Filter the command line history. `Pratical Vim, pp 69`
k("<c-n>", "<down>")
k("<c-p>", "<up>")
