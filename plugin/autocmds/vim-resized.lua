-- Auto resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("ruicsh/vim_resized", { clear = true }),
	command = "wincmd =",
})
