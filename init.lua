vim.loader.enable()

-- colorscheme
vim.cmd.colorscheme("nordstone")

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- load plugins
require("ruicsh.plugins")
