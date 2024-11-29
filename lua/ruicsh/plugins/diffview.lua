-- Diffview
-- https://github.com/sindrets/diffview.nvim

return {
	"sindrets/diffview.nvim",
	keys = {
		{ "<leader>hg", "<cmd>DiffviewOpen<cr>", { desc = "Git: Open diffview" } },
		{ "<leader>hj", "<cmd>DiffviewFileHistory<cr>", { desc = "Git: Log" } },
	},
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
				diff_buf_read = function(buffnr)
					vim.api.nvim_buf_call(buffnr, function()
						vim.cmd("normal! gg]czz")
					end)
				end,
				diff_buf_win_enter = function()
					vim.wo.cursorline = false -- Disable cursorline.
					vim.opt_local.foldenable = false -- Disable folding.
				end,
				diff_buf_win_leave = function()
					vim.wo.cursorline = true -- Enable cursorline.
					vim.opt_local.foldenable = true -- Enable folding.
				end,
				view_enter = function(view)
					vim.cmd(":VimadeDisable") -- Disable dimming windows.
					vim.cmd(":Barbecue hide") -- Hide breadcrumbs.

					local bufnr = view.buffer
					-- Use cc to commit.
					vim.keymap.set("n", "cc", "<cmd>DiffviewClose<cr><cmd>vertical Git commit<cr>", { buffer = bufnr })
				end,
				view_leave = function()
					vim.cmd(":VimadeEnable") -- Reenable dimming windows.
					vim.cmd(":Barbecue show") -- Show breadcrumbs.
				end,
			},
		})
	end,

	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
}
