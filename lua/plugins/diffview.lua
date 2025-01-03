-- Diffview
-- https://github.com/sindrets/diffview.nvim

return {
	"sindrets/diffview.nvim",
	keys = function()
		local mappings = {
			{ "<leader>hg", ":DiffviewOpen<cr>", "Open diffview" },
			{ "<leader>hj", ":DiffviewFileHistory<cr>", "Log" },
		}
		return vim.fn.getlazykeysconf(mappings, "Git")
	end,
	config = function()
		local diffview = require("diffview")
		local actions = require("diffview.actions")

		diffview.setup({
			enhanced_diff_hl = true,
			keymaps = {
				file_panel = {
					{ "n", "<cr>", actions.focus_entry, { desc = "Open and focus the diff" } },
					{ "n", "}", actions.select_next_entry, { desc = "Open the diff for the next file" } },
					{ "n", "{", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
					-- need to redefine this bc of debugprint overriding g?
					{ "n", "g?", actions.help("file_panel") },
				},
				file_history_panel = {
					{ "n", "<cr>", actions.focus_entry, { desc = "Open and focus the diff" } },
					{ "n", "}", actions.select_next_entry, { desc = "Open the log for the next file" } },
					{ "n", "{", actions.select_prev_entry, { desc = "Open the log for the previous file" } },
				},
				help_panel = {
					{ "n", "<c-]>", actions.close },
				},
			},
			hooks = {
				diff_buf_win_enter = function()
					vim.wo.cursorline = false -- Disable cursorline.
					vim.wo.relativenumber = false -- Disable relative numbers.
					vim.cmd("VimadeWinDisable") -- Disable window tint.
				end,
				view_enter = function(view)
					vim.cmd("VimadeWinDisable") -- Disable window tint.
					local bufnr = view.buffer
					-- Use cc to commit.
					local opts = { buffer = bufnr, unique = true }
					vim.keymap.set("n", "cc", ":DiffviewClose<cr>:vertical Git commit<cr>", opts)
				end,
			},
		})
	end,

	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
}
