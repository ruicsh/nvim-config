local k = vim.keymap.set

-- Use nvim-cmp instead of the default autocomplete (when on empty line)
local cmp = require("cmp")
k("i", "<c-n>", cmp.complete)
k("i", "<c-p>", cmp.complete)
