local k = vim.keymap.set

k("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Terminal: Exit" })
k("t", "<c-\\>", "<cmd>terminal<cr>", { desc = "Terminal: New" })
