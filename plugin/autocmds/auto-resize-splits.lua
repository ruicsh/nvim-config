-- Auto resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("ruicsh/auto_resize_splits", { clear = true }),
	command = "wincmd =",
})
