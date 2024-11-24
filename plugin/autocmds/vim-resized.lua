-- Auto resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("ruicsh/VimResized", { clear = true }),
	command = "wincmd =",
})
