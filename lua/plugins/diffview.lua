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
				prompt = "Diffview {git-rev}: ",
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
		local diffview = require("diffview")
		local actions = require("diffview.actions")

		local function git_commit()
			vim.cmd("DiffviewClose")
			vim.cmd.tabnew()
			vim.cmd("Git")
			vim.cmd("wincmd o")
			vim.cmd("vertical Git commit")
		end

		local function toggle_files()
			actions.toggle_files()
			vim.cmd.wincmd("=")
		end

		return {
			enhanced_diff_hl = true, -- ':h diffview-config-enhanced_diff_hl'
			keymaps = {
				file_panel = {
					["<c-q>"] = ":DiffviewClose<cr>",
					["<cr>"] = actions.focus_entry,
					["cc"] = git_commit,
					["<c-b>"] = toggle_files,
				},
				file_history_panel = {
					["<c-n>"] = actions.select_next_commit,
					["<c-p>"] = actions.select_prev_commit,
					["<c-q>"] = ":DiffviewClose<cr>",
					["<cr>"] = actions.focus_entry,
					["<leader>hd"] = function()
						diffview.emit("copy_hash")
						vim.cmd("DiffviewOpen " .. vim.fn.getreg("*") .. "^!")
					end,
					["<c-b>"] = toggle_files,
				},
				help_panel = {
					["q"] = actions.close,
					["<c-q>"] = ":DiffviewClose<cr>",
				},
				panel = {
					["<tab>"] = actions.select_next_entry,
					["<s-tab>"] = actions.select_prev_entry,
				},
				view = {
					{ "n", "co", actions.conflict_choose("ours"), { desc = "Choose OURS" } },
					{ "n", "ct", actions.conflict_choose("theirs"), { desc = "Choose THEIRS" } },
					{ "n", "cb", actions.conflict_choose("all"), { desc = "Choose BOTH" } },
					{ "n", "c0", actions.conflict_choose("none"), { desc = "Choose NONE" } },
					["<c-b>"] = toggle_files,
					["<leader>ca"] = false,
					["<leader>cb"] = false,
					["<leader>co"] = false,
					["<leader>ct"] = false,
					["<leader>cA"] = false,
					["<leader>cB"] = false,
					["<leader>cO"] = false,
					["<leader>cT"] = false,
					["<c-q>"] = ":DiffviewClose<cr>",
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
			view = {
				merge_tool = {
					layout = "diff3_mixed",
				},
			},
		}
	end,
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
}
