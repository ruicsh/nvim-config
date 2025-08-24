-- Grapple's menu

local k = vim.keymap.set
local opts = { buffer = 0 }

-- Navigate bookmarks up/down
k("n", "<c-j>", "j", opts)
k("n", "<c-k>", "k", opts)

-- Move bookmarks up/down on the list
k("n", "<a-k>", ":move .-2<cr>==", opts)
k("n", "<a-j>", ":move .+1<cr>==", opts)
