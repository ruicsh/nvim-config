-- Git buffer integration
-- https://github.com/lewis6991/gitsigns.nvim

local icons = {
  Add = "┃",
  Change = "┋",
  ChangeDelete = "┃",
  Delete = "",
  TopDelete = "",
  Untracked = "┃",
}

return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = icons.Add },
      change = { text = icons.Change },
      delete = { text = icons.Delete },
      topdelete = { text = icons.TopDelete },
      changedelete = { text = icons.ChangeDelete },
      untracked = { text = icons.Untracked },
    },
    signs_staged = {
      add = { text = icons.Add },
      change = { text = icons.Change },
      delete = { text = icons.Delete },
      topdelete = { text = icons.TopDelete },
      changedelete = { text = icons.ChangeDelete },
      untracked = { text = icons.Untracked },
    },
    attach_to_untracked = true,
    current_line_blame = false,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      -- Set keymap, but only if it's not already set
      local function k(mode, l, r, opts)
        opts = vim.tbl_extend("force", { buffer = bufnr, silent = true }, opts or {})
        local modes = type(mode) == "table" and mode or { mode }
        for _, m in ipairs(modes) do
          if not vim.fn.is_keymap_set(m, l) then
            vim.keymap.set(m, l, r, opts)
          end
        end
      end

      -- Navigation
      local function nav_hunk(diff_cmd, direction)
        local function fn()
          if vim.wo.diff then
            vim.cmd.normal({ diff_cmd, bang = true })
          else
            gs.nav_hunk(direction)
          end
        end

        return fn
      end

      k("n", "]c", nav_hunk("]c", "next"))
      k("n", "[c", nav_hunk("[c", "prev"))

      -- Hunks (stage, reset)
      k("n", "<leader>hs", gs.stage_hunk, { desc = "Git: stage hunk" })
      k("n", "<leader>hr", gs.reset_hunk, { desc = "Git: reset hunk" })
      k("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Git: stage hunk" })
      k("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("'."), vim.fn.line("v") })
      end, { desc = "Git: reset hunk" })
    end,
  },

  event = { "BufReadPost", "BufNewFile" },
}
