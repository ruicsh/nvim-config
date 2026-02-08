local T = require("lib.tailwindcss")
T.after_ftplugin()

-- Register the htmlangular parser for the Angular language.
vim.treesitter.language.register("angular", "htmlangular")
vim.cmd("runtime ftplugin/html.vim")
