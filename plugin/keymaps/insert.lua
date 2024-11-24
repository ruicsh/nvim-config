local k = vim.keymap.set

-- Paste with usual shortcut.
k("i", "<c-v>", "<c-r>", { desc = "Paste" })

-- Navigation (alt-* keymaps from vim-rsi don't work on vscode/powershell).
k("i", "<c-r>", "<c-r>+", { desc = "Paste" })
