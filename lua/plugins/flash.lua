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
    labels = "asdfqwerzxcv", -- Limit labels to left side of the keyboard
    modes = {
      char = {
        char_actions = function()
          return {
            [";"] = "next",
            ["F"] = "left",
            ["f"] = "right",
            ["T"] = "left",
            ["t"] = "right",
          }
        end,
        keys = { "f", "F", "t", "T", ";" },
        highlight = {
          backdrop = false,
        },
        jump_labels = false,
        multi_line = false,
      },
      search = {
        enabled = true,
      },
      treesitter = {
        actions = {
          ["+"] = "next",
          ["-"] = "prev",
        },
        labels = "" -- Disable labels for treesitter mode
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
