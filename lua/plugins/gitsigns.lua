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
		current_line_blame = true,
		current_line_blame_formatter = "<author> • <author_time:%R> • <summary>",
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = vim.tbl_extend("force", { buffer = bufnr, unique = true }, opts or {})
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			local function nav_hunk(diff_cmd, direction)
				local function fn()
					if vim.wo.diff then
						vim.cmd("normal! " .. diff_cmd)
					else
						gitsigns.nav_hunk(direction)
					end
				end
				return fn
			end

			map("n", "]c", nav_hunk("]c", "next"))
			map("n", "[c", nav_hunk("[c", "prev"))

			-- Actions
			map({ "n", "v" }, "<leader>hs", gitsigns.stage_hunk, { desc = "Git: [s]tage hunk", buffer = bufnr })
			map({ "n", "v" }, "<leader>hr", gitsigns.reset_hunk, { desc = "Git: [r]eset hunk", buffer = bufnr })
			map({ "n", "v" }, "<leader>hB", gitsigns.blame, { desc = "Git: [b]lame file", buffer = bufnr })
			map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git: [S]tage file" })
			map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git: [R]eset file" })
			map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Git: [u]nstage hunk" })
			map("n", "<leader>hv", gitsigns.preview_hunk_inline, { desc = "Git: pre[v]iew hunk" })

			-- Text object
			map({ "o", "x" }, "ih", ":<c-u>Gitsigns select_hunk<cr>")
		end,
	},

	event = { "VeryLazy" },
}
