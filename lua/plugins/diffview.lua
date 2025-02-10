-- Diffview
-- https://github.com/sindrets/diffview.nvim

return {
	"sindrets/diffview.nvim",
	keys = function()
		local function git_blame_line()
			local line = vim.fn.line(".")
			local blame = vim.fn.systemlist("git blame -L " .. line .. "," .. line .. " " .. vim.fn.expand("%"))
			local hash = blame[1]:match("%w+")
			if hash == "00000000" or hash == "fatal" then
				return
			end

			local cmd = "DiffviewOpen " .. hash .. "^! --selected-file=" .. vim.fn.expand("%")
			vim.cmd(cmd)
		end

		local mappings = {
			{ "<leader>hD", ":DiffviewOpen<cr>", "Open diffview" },
			{ "<leader>hL", ":DiffviewFileHistory<cr>", "Log" },
			{ "<leader>hl", ":DiffviewFileHistory %<cr>", "Log file" },
			{ "<leader>hl", ":'<,'>DiffviewFileHistory<cr>", "Log visual selection", { mode = "v" } },
			{ "<leader>hb", git_blame_line, "Blame line" },
		}
		return vim.fn.get_lazy_keys_conf(mappings, "Git")
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
				end,
			},
		})
	end,

	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
}
