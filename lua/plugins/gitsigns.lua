-- Buffer integration
-- https://github.com/lewis6991/gitsigns.nvim

local icons = require("config/icons")

return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = icons.git.Add },
			change = { text = icons.git.Change },
			delete = { text = icons.git.Delete },
			topdelete = { text = icons.git.TopDelete },
			changedelete = { text = icons.git.ChangeDelete },
			untracked = { text = icons.git.Untracked },
		},
		signs_staged = {
			add = { text = icons.git.Add },
			change = { text = icons.git.Change },
			delete = { text = icons.git.Delete },
			topdelete = { text = icons.git.TopDelete },
			changedelete = { text = icons.git.ChangeDelete },
			untracked = { text = icons.git.Untracked },
		},
		current_line_blame_formatter = "<author> • <author_time:%R> • <summary>",
		current_line_blame_opts = {
			delay = 0,
		},
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			-- Set keymap, but only if it's not already set
			local function k(mode, l, r, opts)
				opts = vim.tbl_extend("force", { buffer = bufnr, silent = true }, opts or {})
				local modes = type(mode) == "table" and mode or { mode }
				for _, m in ipairs(modes) do
					if not vim.fn.iskeymapset(m, l) then
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
						gitsigns.nav_hunk(direction)
					end
				end
				return fn
			end

			k("n", "]c", nav_hunk("]c", "next"))
			k("n", "[c", nav_hunk("[c", "prev"))

			-- Actions
			k({ "n", "v" }, "gh", gitsigns.stage_hunk, { desc = "Git: [s]tage hunk" })
			k({ "n", "v" }, "gH", gitsigns.reset_hunk, { desc = "Git: [r]eset hunk" })
			k("n", "ghb", gitsigns.toggle_current_line_blame, { desc = "Git: [b]lame line" })

			-- Text object
			k({ "o", "x" }, "gh", ":<c-u>Gitsigns select_hunk<cr>", { unique = false })
		end,
	},

	event = { "VeryLazy" },
}
