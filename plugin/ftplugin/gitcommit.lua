-- Git commit panel.

local augroup = vim.api.nvim_create_augroup("ruicsh/ft/gitcommit", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "gitcommit",
	callback = function(event)
		vim.bo.modifiable = true

		vim.cmd("startinsert") -- Start on insert mode.

		local k = vim.keymap.set
		local opts = { buffer = event.buf }
		k({ "n", "i" }, "<c-m>", "<esc>:CopilotChatGenCommitMessage<cr>", opts) -- Generate commit message.
		k({ "n", "i" }, "<c-s>", "<esc>:%s/^\\s\\+//g<cr>:w<cr><c-w>q", opts) -- Save commit message.
	end,
})
