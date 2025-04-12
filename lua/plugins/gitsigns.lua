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
		current_line_blame_formatter = "<author_time:%d-%b-%y> | <summary>",
		current_line_blame_opts = {
			delay = 100,
			virt_text = false,
		},
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

			k("n", "]h", nav_hunk("]c", "next"))
			k("n", "[h", nav_hunk("[c", "prev"))

			-- Hunks (stage, reset)
			k("n", "gh", gs.stage_hunk, { desc = "Git: stage hunk" })
			k("n", "gH", gs.reset_hunk, { desc = "Git: reset hunk" })
			k("v", "gh", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Git: stage hunk" })
			k("v", "gH", function()
				gs.reset_hunk({ vim.fn.line("'."), vim.fn.line("v") })
			end, { desc = "Git: reset hunk" })

			-- Blame
			k("n", "<leader>hB", function()
				local file = vim.fn.expand("%")
				vim.cmd.tabnew()
				vim.cmd.edit(file)
				gs.blame()
			end, { desc = "Git: blame line" })

			-- Diff
			k("n", "<leader>hd", function()
				vim.wo.foldenable = false
				gs.preview_hunk_inline()

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

	event = { "BufReadPost", "BufNewFile" },
}
