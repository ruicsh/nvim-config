-- Indent guides.
-- https://github.com/folke/snacks.nvim/blob/main/docs/indent.md

local DISABLED_FILETYPES = {
  "DiffviewFileHistory",
  "DiffviewFiles",
  "fugitive",
  "help",
  "lazy",
  "markdown",
  "terminal",
}

return {
  "folke/snacks.nvim",
  opts = {
    indent = {
      animate = {
        enabled = false,
      },
      filter = function(buf)
        local ft = vim.bo[buf].filetype
        return vim.tbl_contains(DISABLED_FILETYPES, ft) == false
      end,
      scope = {
        only_current = true,
      },
    },
  },

  event = "BufRead",
}
