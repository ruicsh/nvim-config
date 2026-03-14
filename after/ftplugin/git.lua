local T = require("lib")

vim.opt_local.foldenable = true
vim.opt_local.foldmethod = "syntax"
vim.opt_local.foldlevel = 99
vim.opt_local.wrap = true

-- Close git diff panel with q
vim.keymap.set("n", "q", T.ui.close_side_panels, { buffer = 0, desc = "Close git diff" })
