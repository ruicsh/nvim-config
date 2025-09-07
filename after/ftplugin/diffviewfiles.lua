local k = vim.keymap.set
local opts = { buffer = 0 }

local function git_commit()
	vim.cmd("DiffviewClose")
	vim.cmd.tabnew()
	vim.cmd("Git")
	vim.cmd("wincmd o")
	vim.cmd("vertical Git commit")
end

k("n", "cc", git_commit, opts)
k("n", "<c-q>", ":DiffviewClose<cr>", opts)
