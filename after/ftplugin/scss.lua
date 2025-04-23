-- Handle kebab-case as a word
-- CSS files have this setup by default
-- https://nanotipsforvim.prose.sh/word-boundaries-and-kebab-case-variables
vim.opt_local.iskeyword:append("-")

-- Abbreviations for CSS debug (hotpink)
vim.cmd.abbreviate("hbc border-color: hotpink;")
vim.cmd.abbreviate("hbg background-color: hotpink;")
vim.cmd.abbreviate("hbs box-shadow: 0 0 2px 1px hotpink;")
vim.cmd.abbreviate("hco color: hotpink;")
vim.cmd.abbreviate("hfi fill: hotpink;")
vim.cmd.abbreviate("hoc outline-color: hotpink;")
vim.cmd.abbreviate("hst stroke: hotpink;")
vim.cmd.abbreviate("hts text-shadow: 1px 1px 3px hotpink;")
