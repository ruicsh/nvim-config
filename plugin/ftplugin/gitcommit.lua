-- Git commit panel.

local augroup = vim.api.nvim_create_augroup("ruicsh/ft/gitcommit", { clear = true })

local function accept_commit_message()
	vim.cmd("%s/^\\s*//g") -- trim leading whitespace(s)
	vim.cmd("wq")
end

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "gitcommit",
	callback = function(event)
		vim.bo.modifiable = true

		vim.api.nvim_buf_set_lines(event.buf, 0, -1, false, { "" }) -- empty the buffer

		local k = vim.keymap.set
		local opts = { buffer = event.buf }
		k({ "n", "i" }, "<c-l>", accept_commit_message, opts)

		vim.cmd("CopilotCommitMessage")
	end,
})
