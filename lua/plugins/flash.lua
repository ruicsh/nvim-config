-- Jump around with search labels
-- https://github.com/folke/flash.nvim

return {
  "folke/flash.nvim",
  keys = function()
    local flash = require("flash")

    local mappings = {
      { "s", flash.jump,       "Jump",       mode = { "n", "x", "o" } },
      { "+", flash.treesitter, "Treesitter", mode = { "n", "x", "o" } },
    }

    return vim.fn.get_lazy_keys_conf(mappings, "Flash")
  end,
  opts = {
    highlight = {
      backdrop = false
    },
    labels = "asdfqwerzxcv", -- Limit labels to left side of the keyboard
    modes = {
      char = {
        enabled = false,
      },
      treesitter = {
        actions = {
          ["+"] = "next", -- Increment selection
          ["-"] = "prev", -- Decrement selection
        },
        labels = ""       -- Disable labels for treesitter mode
      },
    },
    prompt = {
      win_config = {
        border = "none",
      },
    },
    search = {
      wrap = true,
    },
  },

  event = "VeryLazy",
}
