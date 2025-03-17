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

		vim.opt_local.textwidth = 0 -- Disable text width
		vim.opt_local.wrapmargin = 0 -- Disable wrap margin
		vim.opt_local.formatoptions:remove("t") -- Remove auto-wrap option

		local k = vim.keymap.set
		local opts = { buffer = event.buf }

		k({ "n", "i" }, "<c-y>", accept_commit_message, opts)
		k({ "n", "i" }, "<leader>ac", ":CopilotCommitMessage<cr>", opts)
	end,
})
