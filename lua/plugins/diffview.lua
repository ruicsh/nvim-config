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

		local function diff_back()
			require("snacks.input").input({
				prompt = "Diffview Range (HEAD..HEAD~{count}): ",
				default = "HEAD..HEAD~" .. tostring(vim.v.count > 0 and vim.v.count or 1),
			}, function(input)
				vim.cmd("DiffviewOpen " .. input)
			end)
		end

		local mappings = {
			{ "<leader>hd", ":DiffviewOpen<cr>", "Diffview" },
			{ "<leader>hl", ":DiffviewFileHistory<cr>", "Log" },
			{ "<leader>he", ":DiffviewFileHistory %<cr>", "Log for file" },
			{ "<leader>hl", ":'<,'>DiffviewFileHistory<cr>", "Log visual selection", { mode = "v" } },
			{ "<leader>hb", git_blame_line, "Blame line" },
			{ "<leader>hD", diff_back, "Diffview HEAD~{count}..HEAD" },
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
					{ "n", "<c-n>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
					{ "n", "<c-p>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
					-- Disable default tab mappings
					{ "n", "<tab>", "<nop>" },
					{ "n", "<s-tab>", "<nop>" },
				},
				file_history_panel = {
					{ "n", "<cr>", actions.focus_entry, { desc = "Open and focus the diff" } },
					{ "n", "<c-n>", actions.select_next_entry, { desc = "Open the log for the next file" } },
					{ "n", "<c-p>", actions.select_prev_entry, { desc = "Open the log for the previous file" } },
					-- Disable default tab mappings
					{ "n", "<tab>", "<nop>" },
					{ "n", "<s-tab>", "<nop>" },
				},
				help_panel = {
					{ "n", "q", actions.close },
				},
			},
			hooks = {
				diff_buf_read = function(bufnr)
					vim.schedule(function()
						vim.api.nvim_buf_call(bufnr, function()
							vim.cmd("normal! gg]czz") -- Focus the first hunk and center it.
						end)
					end)
				end,
			},
		}
	end,
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
}
