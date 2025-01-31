-- Git commit panel.

local augroup = vim.api.nvim_create_augroup("ruicsh/ft/gitcommit", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "gitcommit",
	callback = function(event)
		vim.cmd("startinsert", { silent = true }) -- Start on insert mode.

		local k = vim.keymap.set
		local opts = { buffer = event.buf }
		-- Use <c-s> to save the commit message.
		k("i", "<c-s>", "<esc>:w<cr><c-w>q", opts)
	end,
})
