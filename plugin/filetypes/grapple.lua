-- Grapple's menu

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/grapple", { clear = true })

vim.api.nvim_create_autocmd("WinClosed", {
  group = augroup,
  callback = function()
    local ft = vim.bo.filetype
    if ft == "grapple" then
      local grapple = require("grapple")

      -- The order may have been changed, so we need to reset and reassign
      local tags = grapple.tags()
      grapple.reset()
      local names = { "a", "s", "d", "f", "g", "h", "j", "k", "l" }
      for index, tag in ipairs(tags) do
        grapple.tag({ index = index, name = names[index], path = tag.path })
      end
    end
  end,
})
