local k = vim.keymap.set
local opts = { buffer = 0 }

k("n", "<c-q>", ":DiffviewClose<cr>", opts)
