-- Dockerfile

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/dockerfile", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = { "Dockerfile", "dockerfile", "dockerfile.*" },
  callback = function()
    if vim.bo.filetype == "lua" then
      return
    end

    -- Set the filetype to any files with dockerfile in the name
    vim.bo.filetype = "dockerfile"
  end,
})
