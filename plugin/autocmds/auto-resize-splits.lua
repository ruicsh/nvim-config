-- Auto resize splits when window is resized

local group = vim.api.nvim_create_augroup("ruicsh/auto_resize_splits", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
	group = group,
	command = "wincmd =",
})
