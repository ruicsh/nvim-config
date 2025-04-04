vim.wo.wrap = true
vim.bo.buflisted = false

local k = vim.keymap.set
local opts = { buffer = 0 }
k("n", "<leader>hp", ":Git push<cr>", opts)
k("n", "<leader>ho", ":Git push --set-upstream origin HEAD<cr>", opts)
k("n", "<leader>ar", ":CopilotCodeReview<cr>", opts)
