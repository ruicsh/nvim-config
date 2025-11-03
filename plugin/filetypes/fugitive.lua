local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/fugitive", { clear = true })

vim.api.nvim_create_autocmd("BufRead", {
  group = augroup,
  pattern = "fugitive://*",
  callback = function()
    vim.cmd("normal ]/") -- Jump to the first entry
  end,
})
