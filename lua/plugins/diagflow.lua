-- Diagnostics on the top right corner of the screen
-- https://github.com/dgagn/diagflow.nvim

return {
  "dgagn/diagflow.nvim",
  opts = {
    max_height = 50,
    padding_right = 1,
  },

  event = "LspAttach",
}
