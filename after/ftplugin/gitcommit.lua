vim.opt_local.modifiable = true
vim.opt_local.textwidth = 0 -- Disable text width
vim.opt_local.wrapmargin = 0 -- Disable wrap margin
vim.opt_local.linebreak = true -- Break lines at word boundaries
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.signcolumn = "yes:1"

local k = vim.keymap.set
local opts = { buffer = 0 }

local function accept_commit_message()
	vim.cmd("%s/^\\s*//g") -- trim leading whitespace(s)
	vim.cmd("wq")
end

k({ "n", "i" }, "<c-y>", accept_commit_message, opts)
k({ "n", "i" }, "<leader>ac", ":CopilotCommitMessage<cr>", opts)
