local k = vim.keymap.set
local opts = { buffer = true, noremap = true }

-- Bring back the default behavior of <cr> that we changed to remove the search highlight.
k("n", "<cr>", "<cr>", opts)
