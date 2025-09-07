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
		local actions = require("diffview.actions")

		local function git_commit()
			vim.cmd("DiffviewClose")
			vim.cmd.tabnew()
			vim.cmd("Git")
			vim.cmd("wincmd o")
			vim.cmd("vertical Git commit")
		end

		return {
			enhanced_diff_hl = true, -- ':h diffview-config-enhanced_diff_hl'
			keymaps = {
				file_panel = {
					["<c-n>"] = actions.select_next_entry,
					["<c-p>"] = actions.select_prev_entry,
					["<c-q>"] = ":DiffviewClose<cr>",
					["<cr>"] = actions.focus_entry,
					["<s-tab>"] = "<nop>",
					["<tab>"] = "<nop>",
					["cc"] = git_commit,
				},
				file_history_panel = {
					["<c-n>"] = actions.select_next_entry,
					["<c-p>"] = actions.select_prev_entry,
					["<c-q>"] = ":DiffviewClose<cr>",
					["<cr>"] = actions.focus_entry,
					["<s-tab>"] = "<nop>",
					["<tab>"] = "<nop>",
				},
				help_panel = {
					{ "n", "q", actions.close },
				},
			},
			hooks = {
				diff_buf_read = function(bufnr)
					vim.b.minidiff_disable = true

					local k = vim.keymap.set
					local opts = { buffer = bufnr, silent = true }

					-- Hunk navigation
					k("n", "[c", "[c", opts)
					k("n", "]c", "]c", opts)

					-- Close diffview
					k("n", "<c-q>", ":DiffviewClose<cr>", opts)

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
