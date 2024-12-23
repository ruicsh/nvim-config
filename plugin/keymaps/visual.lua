local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
	vim.keymap.set("x", lhs, rhs, options)
end

-- Sort
k("<leader>so", "<esc>:Sort<cr>", { desc = "[S]ort" })

-- Search and replace
k("<leader>r", ":s/", { desc = "Replace within selection" })

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

-- Maintain the cursor position when yanking a visual selection.
-- https://ddrscott.github.io/blog/2016/yank-without-jank/
k("y", "myy`y:delmarks y<cr>", { silent = true })
k("Y", "myY`y:delmarks y<cr>", { silent = true })
