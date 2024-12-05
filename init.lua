vim.loader.enable()

-- Colorscheme
vim.cmd.colorscheme("nordstone")

-- Leader key
-- needs to be set before lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")
