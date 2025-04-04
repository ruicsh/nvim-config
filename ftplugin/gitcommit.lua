vim.bo.modifiable = true

vim.bo.textwidth = 0 -- Disable text width
vim.bo.wrapmargin = 0 -- Disable wrap margin

local k = vim.keymap.set
local opts = { buffer = 0 }

local function accept_commit_message()
	vim.cmd("%s/^\\s*//g") -- trim leading whitespace(s)
	vim.cmd("wq")
end

k({ "n", "i" }, "<c-y>", accept_commit_message, opts)
k({ "n", "i" }, "<leader>ac", ":CopilotCommitMessage<cr>", opts)
