-- Jump around with search labels
-- https://github.com/folke/flash.nvim

return {
  "folke/flash.nvim",
  keys = function()
    local flash = require("flash")

    local mappings = {
      { "+", flash.treesitter, "Treesitter", mode = { "n", "x", "o" } },
    }

    return vim.fn.get_lazy_keys_conf(mappings, "Flash")
  end,
  opts = {
    label = {
      style = "inline",      -- Don't hide the character under the cursor
    },
    labels = "asdfqwerzxcv", -- Limit labels to left side of the keyboard
    modes = {
      char = {
        enabled = false,
      },
      search = {
        enabled = true,
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
