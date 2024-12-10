-- Always open help panel on a vertical split, full height.
-- https://github.com/dmmulroy/kickstart.nix/blob/main/config/nvim/
vim.bo.bufhidden = "unload"
vim.cmd.wincmd("L")
vim.cmd.wincmd("=")
