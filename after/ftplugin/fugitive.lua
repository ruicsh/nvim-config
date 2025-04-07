vim.wo.wrap = true
vim.bo.buflisted = false

local k = vim.keymap.set
local opts = { buffer = 0 }

k("n", "<leader>ar", ":CopilotCodeReview<cr>", opts)
k("n", "<leader>hps", ":Git push<cr>", opts)
k("n", "<leader>hpu", ":Git push --set-upstream origin HEAD<cr>", opts)
k("n", "<leader>hpf", ":Git push --force-with-lease<cr>", opts)
