-- Git buffer integration
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
		attach_to_untracked = true,
		current_line_blame = true,
		current_line_blame_formatter = "<author> • <author_time:%R> • <summary>",
		current_line_blame_opts = { delay = 2000 },
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

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
						gitsigns.nav_hunk(direction)
					end
				end

				return fn
			end

			k("n", "]c", nav_hunk("]c", "next"))
			k("n", "[c", nav_hunk("[c", "prev"))

			-- Actions
			k("n", "gh", gitsigns.stage_hunk, { desc = "Git: stage hunk" })
			k("n", "gH", gitsigns.reset_hunk, { desc = "Git: reset hunk" })
			k("v", "gh", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Git: stage hunk" })

			k("v", "gH", function()
				gitsigns.reset_hunk({ vim.fn.line("'."), vim.fn.line("v") })
			end, { desc = "Git: reset hunk" })

			k("n", "<leader>hd", function()
				vim.wo.foldenable = false
				gitsigns.preview_hunk_inline()

				-- reenable foldenable after preview
				vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
					callback = function()
						vim.wo.foldenable = true
					end,
					once = true,
				})
			end)

			-- Text object
			k({ "o", "x" }, "ih", ":Gitsigns select_hunk<cr>", { unique = false })
		end,
	},

	event = { "VeryLazy" },
}
