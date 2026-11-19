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

-- gitsigns already skips non-normal buffers (buftype ~= ""), so UI, picker,
-- and terminal buffers need no entry here.
local EXCLUDE_FILETYPES = {
	"fugitive",
	"gitcommit",
	"gitrebase",
}

return {
	"lewis6991/gitsigns.nvim",
	opts = {
		-- Keep gitsigns' glyphs on top of mini.diff's blank overlay signs.
		sign_priority = 200,
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
		current_line_blame = true,
		current_line_blame_formatter = "<author_time:%R> - <summary>",
		current_line_blame_opts = {
			delay = 2000,
			virt_text_pos = "right_align",
		},
		on_attach = function(bufnr)
			-- Don't attach to excluded filetypes
			if vim.tbl_contains(EXCLUDE_FILETYPES, vim.bo[bufnr].filetype) then
				return
			end

			local gs = package.loaded.gitsigns

			local function k(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
			end

			-- In diff mode, defer to diff's own hunk motions.
			local function nav_hunk(direction)
				local cmd = direction == "next" and "]c" or "[c"
				return function()
					if vim.wo.diff then
						vim.cmd("normal! " .. cmd)
					else
						gs.nav_hunk(direction)
					end
				end
			end

			k("n", "]c", nav_hunk("next"), "Git: next hunk")
			k("n", "[c", nav_hunk("prev"), "Git: prev hunk")

			-- Stage (also unstages when the cursor is on a staged hunk)
			k("n", "<leader>hs", gs.stage_hunk, "Git: stage hunk")
			k("n", "<leader>hS", gs.stage_buffer, "Git: stage file")
			k("v", "<leader>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v", true) })
			end, "Git: stage hunk")

			-- Reset
			k("n", "<leader>hr", gs.reset_hunk, "Git: discard hunk")
			k("n", "<leader>hR", gs.reset_buffer, "Git: discard file")
			k("v", "<leader>hr", function()
				gs.reset_hunk({ vim.fn.line("'<"), vim.fn.line("'>") })
			end, "Git: reset hunk")
		end,
	},
}
