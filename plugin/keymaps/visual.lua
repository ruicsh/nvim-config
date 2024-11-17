local k = vim.keymap.set

-- Sort
k("v", "<leader>so", "<esc><cmd>Sort<cr>", { desc = "[S]ort" })

-- Search and replace
k("x", "<leader>r", ":s/", { desc = "Replace within selection" })

-- Keep visual selection after indenting.
k("v", "<<", "<gv")
k("v", ">>", ">gv")

-- Paste over currently selected text without yanking it.
k("v", "P", '"_dP')
k("v", "X", '"_X')
k("v", "c", '"_c')
k("v", "p", '"_dp')
k("v", "x", '"_x')

-- Remove search highlighting.
k("v", "<cr>", "<cmd>noh<cr>")
