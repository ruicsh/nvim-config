local k = vim.keymap.set
local opts = { buffer = true, noremap = true }

k("n", "<cr>", "<cr><cmd>cclose<cr>", opts) -- Close the quickfix when opening a file
