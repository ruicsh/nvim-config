-- Detect and set the proper file type for Angular Template files.

local group = vim.api.nvim_create_augroup("ruicsh/ftdetect/htmlangular", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group,
  pattern = "*.component.html",
  callback = function()
    vim.bo.filetype = "htmlangular"
  end,
})
