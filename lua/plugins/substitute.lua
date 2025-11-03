-- Replace and exchange actions.
-- https://github.com/gbprod/substitute.nvim

return {
  "gbprod/substitute.nvim",
  keys = function()
    local s = require("substitute")

    local mappings = {
      -- Substitute
      { "<leader>r",  s.operator, "Operator" },
      { "<leader>rr", s.line,     "Line" },
      { "<leader>r$", s.eol,      "End of line" },
      { "<leader>r",  s.visual,   "Selection",  { mode = "x" } },
    }

    return vim.fn.get_lazy_keys_conf(mappings, "Substitute")
  end,
  opts = {
    exchange = {},
  },
}
