local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("v", lhs, rhs, options)
end

-- Keep visual selection after indenting.
k("<<", "<gv")
k(">>", ">gv")

-- Paste over currently selected text without yanking it.
k("P", '"_dP')
k("X", '"_X')
k("c", '"_c')
k("p", '"_dp')
k("x", '"_x')

-- Navigation
k("{", "6k")
k("}", "6j")
k("H", "0^")
k("L", "$")

k("|", "<c-w>w", { desc = "Windows: Switch" })
