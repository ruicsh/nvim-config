vim.loader.enable()

vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode(",")

vim.cmd("colorscheme nordstone")

require("config.lazy")
