vim.opt_local.linebreak = true -- Break lines at word boundaries
vim.opt_local.modifiable = true
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.signcolumn = "yes:1"
vim.opt_local.textwidth = 0 -- Disable text width
vim.opt_local.wrap = true -- Enable line wrapping

local k = vim.keymap.set
local opts = { buffer = 0 }

local function accept_commit_message()
	vim.cmd("%s/^\\s*//g") -- trim leading whitespace(s)
	vim.cmd("wq")
end

k({ "n", "i" }, "<c-s>", accept_commit_message, opts)
k({ "n" }, "<leader>ac", ":CopilotCommitMessage<cr>", opts)
k({ "n" }, "q", "<cmd>q!<cr>", opts) -- Close the buffer

-- Start in insert mode
vim.cmd.startinsert()
