local k = vim.keymap.set
local opts = { noremap = true, buffer = true }

-- Use <c-s> to save the commit message.
k("i", "<c-s>", "<esc><cmd>w<cr><c-w>q", opts)

-- Start on insert mode.
vim.cmd("startinsert", { silent = true })
