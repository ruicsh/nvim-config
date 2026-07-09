vim.loader.enable()

vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode(",")

require("vim._core.ui2").enable()

vim.cmd("colorscheme nordstone")

require("config.lazy")
