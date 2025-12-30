-- Grapple's menu

local k = vim.keymap.set
local opts = { buffer = 0 }

-- Move bookmarks up/down on the list
k("n", "<a-k>", "<cmd>move .-2<cr>==", opts)
k("n", "<a-j>", "<cmd>move .+1<cr>==", opts)
