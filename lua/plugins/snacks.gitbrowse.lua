-- Open the repo of the active file in the browser.
-- https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md

return {
  "folke/snacks.nvim",
  keys = (function()
    local snacks = require("snacks")

    local mappings = {
      { "<leader>hxe", snacks.gitbrowse.open, "Open file in browser" },
    }

    return vim.fn.get_lazy_keys_conf(mappings, "Git")
  end)(),
  ops = {
    gitbrowse = {
      enabled = true,
    },
  },

  event = "BufRead",
}
