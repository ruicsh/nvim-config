-- Git diffview
-- https://github.com/sindrets/diffview.nvim

return {
	"sindrets/diffview.nvim",
	keys = function()
		local function git_blame_line()
			local notify = require("mini.notify")
			local blame = vim.git.blame()

			if blame.commit:match("^00000000") or blame.commit == "fatal" then
				local id = notify.add("Not commited yet.", "WARN")
				vim.defer_fn(function()
					notify.remove(id)
				end, 3000)

				return
			end

			_G.diffview_blame = blame

			local cmd = "DiffviewOpen " .. blame.commit .. "^! --selected-file=" .. vim.fn.expand("%")
			vim.cmd(cmd)
		end

		local mappings = {
			{ "<leader>hD", ":DiffviewOpen<cr>", "Diffview" },
			{ "<leader>hL", ":DiffviewFileHistory<cr>", "Log" },
			{ "<leader>hl", ":DiffviewFileHistory %<cr>", "Log for file" },
			{ "<leader>hl", ":'<,'>DiffviewFileHistory<cr>", "Log visual selection", { mode = "v" } },
			{ "<leader>hb", git_blame_line, "Blame line" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Git")
	end,
	opts = function()
		local actions = require("diffview.actions")

		return {
			enhanced_diff_hl = true,
			keymaps = {
				file_panel = {
					{ "n", "<cr>", actions.focus_entry, { desc = "Open and focus the diff" } },
					{ "n", "{", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
					{ "n", "}", actions.select_next_entry, { desc = "Open the diff for the next file" } },
					{ "n", "k", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
					{ "n", "j", actions.select_next_entry, { desc = "Open the diff for the next file" } },
				},
				file_history_panel = {
					{ "n", "<cr>", actions.focus_entry, { desc = "Open and focus the diff" } },
					{ "n", "{", actions.select_prev_entry, { desc = "Open the log for the previous file" } },
					{ "n", "}", actions.select_next_entry, { desc = "Open the log for the next file" } },
					{ "n", "k", actions.select_prev_entry, { desc = "Open the log for the previous file" } },
					{ "n", "j", actions.select_next_entry, { desc = "Open the log for the next file" } },
				},
				help_panel = {
					{ "n", "<c-]>", actions.close },
				},
			},
			hooks = {
				diff_buf_win_enter = function()
					vim.wo.cursorline = false -- Disable cursorline.
					vim.wo.relativenumber = false -- Disable relative numbers.
				end,
			},
		}
	end,

	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	enabled = not vim.g.vscode,
}
