vim.opt_local.bufhidden = "unload"

local k = vim.keymap.set
local opts = { buffer = true }

-- Better navigation.
-- https://vim.fandom.com/wiki/Learn_to_use_help#Simplify_help_navigation
k("n", "<cr>", "<c-]>", opts) -- `:h ctrl-]`
k("n", "<bs>", "<c-T>", opts) -- `:h ctrl-t`

-- Close help with `q` but not the window
k("n", "q", require("snacks").bufdelete.delete, opts)
