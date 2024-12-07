local k = vim.keymap.set
local opts = { silent = true, buffer = true, noremap = true }

k("n", "<cr>", "<cr><cmd>cclose<cr>", opts) -- Close the quickfix when opening a file

-- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/after/ftplugin/qf.lua
vim.wo.number = true
vim.wo.relativenumber = true
vim.opt_local.list = false
vim.o.buflisted = false

vim.cmd.packadd("cfilter")

-- Search and replace on quickfix files.
-- https://github.com/theHamsta/dotfiles/blob/master/.config/nvim/ftplugin/qf.lua
k("n", "<leader>r", function()
	local fk = vim.api.nvim_feedkeys
	local tc = vim.api.nvim_replace_termcodes
	local listdo = vim.fn.getloclist(0, { winid = 0 }).winid == 0 and "cdo" or "ldo"
	-- :cdo s//<left><left>
	local cmd = ":" .. listdo .. " s//g<left><left>"
	fk(tc(cmd, true, false, true), "n", false)
end)

-- Remove quickfix entry.
-- https://github.com/famiu/dot-nvim/blob/master/ftplugin/qf.lua
k("n", "dd", function()
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local qflist = vim.fn.getqflist()
	-- Remove line from qflist.
	table.remove(qflist, line)
	vim.fn.setqflist(qflist, "r")
	-- Restore cursor position.
	local max_lines = vim.api.nvim_buf_line_count(0)
	vim.api.nvim_win_set_cursor(0, { math.min(line, max_lines), 0 })
end)
