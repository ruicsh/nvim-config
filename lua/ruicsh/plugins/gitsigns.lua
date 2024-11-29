-- Buffer integration
-- https://github.com/lewis6991/gitsigns.nvim

local config = require("ruicsh/config")

return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = config.icons.git.Add },
			change = { text = config.icons.git.Change },
			delete = { text = config.icons.git.Delete },
			topdelete = { text = config.icons.git.TopDelete },
			changedelete = { text = config.icons.git.ChangeDelete },
			untracked = { text = config.icons.git.Untracked },
		},
		signs_staged = {
			add = { text = config.icons.git.Add },
			change = { text = config.icons.git.Change },
			delete = { text = config.icons.git.Delete },
			topdelete = { text = config.icons.git.TopDelete },
			changedelete = { text = config.icons.git.ChangeDelete },
			untracked = { text = config.icons.git.Untracked },
		},
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Git: Jump to next [c]hange" })

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Git: Jump to previous [c]hange" })

			-- Actions
			map({ "n", "v" }, "<leader>hs", gitsigns.stage_hunk, { desc = "Git: [s]tage hunk", buffer = bufnr })
			map({ "n", "v" }, "<leader>hr", gitsigns.reset_hunk, { desc = "Git: [r]eset hunk", buffer = bufnr })
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
