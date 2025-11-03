-- HTTP client
-- https://github.com/mistweaverco/kulala.nvim

return {
  "mistweaverco/kulala.nvim",
  opts = {
    global_keymaps = true,
    global_keymaps_prefix = "<leader>k",
    kulala_keymaps_prefix = "",
    kulala_keymaps = {
      ["Toggle split/float"] = false,
    },
  },

  ft = { "http", "rest" },
}
