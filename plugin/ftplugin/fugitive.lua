-- Fugitive panel.

local augroup = vim.api.nvim_create_augroup("ruicsh/ft/fugitive", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "fugitive",
	callback = function(event)
		vim.bo.buflisted = false

		local k = vim.keymap.set
		local opts = { buffer = event.buf }
		k("n", "<leader>hp", ":Git push<cr>", opts)
		k("n", "<leader>ho", ":Git push --set-upstream origin HEAD<cr>", opts)
	end,
})
