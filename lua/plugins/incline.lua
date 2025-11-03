-- Floating statusline.
-- https://github.com/b0o/incline.nvim

return {
  "b0o/incline.nvim",
  opts = {
    render = function(props)
      local api = vim.api
      local bufnr = props.buf

      -- Don't show if the cursor is on the first line of the current window
      local cursor = api.nvim_win_get_cursor(0)
      if cursor[1] == 1 and props.win == api.nvim_get_current_win() then
        return {}
      end

      local grapple = require("grapple")
      local grapple_tag = grapple.exists({ buffer = bufnr }) and grapple.find({ buffer = bufnr })
      local grapple_part = {}
      if grapple_tag then
        grapple_part = {
          "󰛢" .. grapple_tag.name .. " ",
          group = "InclineGrapple",
        }
      end

      local bufname = api.nvim_buf_get_name(bufnr)
      local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or ""
      if api.nvim_buf_get_option(bufnr, "modified") then
        filename = filename .. " [+]"
      end

      return { grapple_part, filename }
    end,
  },

  dependencies = {
    "cbochs/grapple.nvim",
  },
}
