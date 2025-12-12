vim.opt_local.bufhidden = "unload"
-- Schedule to override the defaults
vim.schedule(function()
	vim.opt_local.signcolumn = "yes" -- Shows left padding on the window
end)

local k = vim.keymap.set
local opts = { buffer = true }

-- Better navigation.
-- https://vim.fandom.com/wiki/Learn_to_use_help#Simplify_help_navigation
k("n", "<cr>", "<c-]>", opts) -- `:h ctrl-]`
k("n", "<bs>", "<c-T>", opts) -- `:h ctrl-t`
