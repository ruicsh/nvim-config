local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("v", lhs, rhs, options)
end

-- Keep visual selection after indenting.
k("<", "<gv")
k(">", ">gv")

-- Paste over currently selected text without yanking it.
k("P", '"_dP')
k("X", '"_X')
k("c", '"_c')
k("p", '"_dp')
k("x", '"_x')

-- Navigation
k("{", "6k")
k("}", "6j")

-- Move lines
k("]e", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
k("[e", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

k("|", "<c-w>w", { desc = "Windows: Switch" })
