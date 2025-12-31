-- Git buffer integration
-- https://github.com/lewis6991/gitsigns.nvim

local T = require("lib")

local icons = {
	Add = "┃",
	Change = "┋",
	ChangeDelete = "┃",
	Delete = "",
	TopDelete = "",
	Untracked = "┃",
}

local EXCLUDE_FILETYPES = {
	"lazy",
	"mason",
	"toggleterm",
	"fugitive",
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
		attach_to_untracked = false,
		current_line_blame = true,
		current_line_blame_formatter = "<author_time:%R> - <summary>",
		current_line_blame_opts = {
			delay = 2000,
			virt_text_pos = "right_align",
		},
		on_attach = function(bufnr)
			-- Don't attach to excluded filetypes
			local ft = vim.bo[bufnr].filetype
			for _, excluded_ft in ipairs(EXCLUDE_FILETYPES) do
				if ft == excluded_ft then
					return
				end
			end

			local gs = package.loaded.gitsigns

			-- Set keymap, but only if it's not already set
			local function k(mode, l, r, opts)
				opts = vim.tbl_extend("force", { buffer = bufnr, silent = true }, opts or {})
				local modes = type(mode) == "table" and mode or { mode }
				for _, m in ipairs(modes) do
					if not T.fn.is_keymap_set(m, l) then
						vim.keymap.set(m, l, r, opts)
					end
				end
			end

			-- Navigation
			local function nav_hunk(diff_cmd, direction)
				local function fn()
					if vim.wo.diff then
						vim.cmd("normal! " .. diff_cmd)
					else
						gs.nav_hunk(direction)
					end
				end

				return fn
			end

			-- Navigation
			k("n", "]c", nav_hunk("]c", "next"))
			k("n", "[c", nav_hunk("[c", "prev"))

			-- Stage
			k("n", "<leader>hs", gs.stage_hunk, { desc = "Git: stage hunk" })
			k("n", "<leader>hS", gs.stage_buffer, { desc = "Git: stage buffer" })
			k("v", "<leader>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Git: stage hunk" })

			-- Reset
			k("n", "<leader>hr", gs.reset_hunk, { desc = "Git: reset hunk" })
			k("n", "<leader>hR", gs.reset_buffer, { desc = "Git: reset buffer" })
			k("v", "<leader>hr", function()
				gs.reset_hunk({ vim.fn.line("'."), vim.fn.line("v") })
			end, { desc = "Git: reset hunk" })

			-- Preview
			k("n", "<leader>hd", gs.preview_hunk, { desc = "Git: Preview hunk" })
		end,
	},

	event = { "BufReadPost" },
}
