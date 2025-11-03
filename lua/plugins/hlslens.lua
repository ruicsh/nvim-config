-- Search results lens
-- https://github.com/kevinhwang91/nvim-hlslens

return {
  "kevinhwang91/nvim-hlslens",
  keys = function()
    local hlslens = require("hlslens")

    local function browse(key)
      return function()
        vim.cmd("normal! " .. vim.v.count1 .. key .. "zv")
        hlslens.start()
      end
    end

    local function start_search(keys)
      return function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
        vim.cmd("normal! zv")
        hlslens.start()
      end
    end

    local mappings = {
      { "n",  browse("n"),            "Next result" },
      { "N",  browse("N"),            "Previous result" },
      { "*",  start_search("*"),      "Search word under cursor forward" },
      { "g/", start_search("*"),      "Search word under cursor forward" },
      { "[/", start_search("[<c-i>"), "Search word under cursor forward" },
      { "#",  start_search("#"),      "Search word under cursor backward" },
      { "g*", start_search("g*"),     "Search word under cursor forward (partial)" },
      { "g#", start_search("g#"),     "Search word under cursor backward (partial)" },
    }

    return vim.fn.get_lazy_keys_conf(mappings, "Search")
  end,
  opts = {
    calm_down = true,
    nearest_only = true,
  },

  event = "VeryLazy",
}
