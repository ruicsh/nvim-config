local k = vim.keymap.set
local opts = { noremap = true, buffer = true }

k("n", "<leader>hp", "<cmd>Git push<cr>", opts)
k("n", "<leader>ho", "<cmd>Git push --set-upstream origin HEAD<cr>", opts)

vim.bo.buflisted = false
