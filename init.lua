vim.loader.enable()

-- Colorscheme
vim.cmd.colorscheme("nordstone")

-- Leader key
-- needs to be set before lazy.nvim
vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode("<space>")

require("ruicsh")
require("config.lazy")

-- LSP config
vim.fn.setup_lsp()
