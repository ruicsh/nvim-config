local k = vim.keymap.set

-- Paste with usual shortcut.
k("i", "<c-v>", "<c-r>", { desc = "Paste" })

-- Navigation (alt-* keymaps from vim-rsi don't work on vscode/powershell).
k("i", "<c-j>", "<c-o>j", { desc = "Jump down a line" })
k("i", "<c-k>", "<c-o>k", { desc = "Jump up a line" })
k("i", "<c-r>", "<c-r>+", { desc = "Paste" })
