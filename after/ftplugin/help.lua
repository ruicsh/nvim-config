vim.opt_local.bufhidden = "unload"

local k = vim.keymap.set
local opts = { buffer = true }

-- Better navigation.
-- https://vim.fandom.com/wiki/Learn_to_use_help#Simplify_help_navigation
k("n", "<cr>", "<c-]>", opts)
k("n", "<bs>", "<c-T>", opts)
