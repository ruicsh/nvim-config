local k = vim.keymap.set
local opts = { buffer = true, noremap = true }

-- When deleting the path, have it trigger a new search.
k("n", "D", "A<c-u><esc>", opts)
