local k = vim.keymap.set

-- Sort
k("x", "<leader>so", "<esc><cmd>Sort<cr>", { desc = "[S]ort" })

-- Search and replace
k("x", "<leader>r", ":s/", { desc = "Replace within selection" })

-- Keep visual selection after indenting.
k("x", "<<", "<gv")
k("x", ">>", ">gv")

-- Paste over currently selected text without yanking it.
k("x", "P", '"_dP')
k("x", "X", '"_X')
k("x", "c", '"_c')
k("x", "p", '"_dp')
k("x", "x", '"_x')

-- Remove search highlighting.
k("x", "<esc>", "<cmd>noh<cr>")

-- Augmented HJKL
k("x", "J", "6j")
k("x", "K", "6k")
k("x", "H", "0^")
k("x", "L", "$")

-- Maintain the cursor position when yanking a visual selection.
-- https://ddrscott.github.io/blog/2016/yank-without-jank/
k("x", "y", "myy`y")
k("x", "Y", "myY`y")
