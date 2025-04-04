-- Always open help panel on a vertical split, full height.
-- https://github.com/dmmulroy/kickstart.nix/blob/main/config/nvim/
vim.bo.bufhidden = "unload"
vim.cmd.wincmd("L")
vim.cmd.wincmd("=")

local k = vim.keymap.set
local opts = { buffer = true }

-- Better navigation.
-- https://vim.fandom.com/wiki/Learn_to_use_help#Simplify_help_navigation
k("n", "<bs>", "<c-T>", opts)
