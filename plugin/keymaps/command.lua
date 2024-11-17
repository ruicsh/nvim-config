local k = vim.keymap.set
local opts = { noremap = true, buffer = true, silent = true }

-- Move up/down in the history and in wildmenu.
k("c", "<c-k>", "<c-p>", opts)
k("c", "<c-j>", "<c-n>", opts)
