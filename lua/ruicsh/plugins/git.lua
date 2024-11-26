--
-- Git
--

return {
	{ -- Git client
		-- https://github.com/tpope/vim-fugitive
		"tpope/vim-fugitive",

		lazy = true,
		cmd = "Git",
	},

	{ -- Git blame (git-blame.nvim).
		-- https://github.com/f-person/git-blame.nvim
		"f-person/git-blame.nvim",
		opts = {
			enabled = true,
			message_template = "<summary> • <date> • <author>",
			date_format = "%r",
			message_when_not_committed = "Not commited yet",
			ignored_filetypes = { "term" },
		},

		event = { "BufEnter" },
	},

	{ -- Merge conflicts
		-- https://github.com/akinsho/git-conflict.nvim
		"akinsho/git-conflict.nvim",
		config = true,

		event = { "BufEnter" },
	},

	{ -- Diffview
		-- https://github.com/sindrets/diffview.nvim
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
						vim.keymap.set(
							"n",
							"cc",
							"<cmd>DiffviewClose<cr><cmd>vertical Git commit<cr>",
							{ buffer = bufnr }
						)
					end,
					view_leave = function()
						vim.cmd(":VimadeEnable") -- Reenable dimming windows.
						vim.cmd(":Barbecue show") -- Show breadcrumbs.
					end,
				},
			})
		end,

		cmd = { "DiffviewOpen" },
	},

	{ -- Buffer integration
		-- https://github.com/lewis6991/gitsigns.nvim
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = ThisNvimConfig.icons.git.Add },
				change = { text = ThisNvimConfig.icons.git.Change },
				delete = { text = ThisNvimConfig.icons.git.Delete },
				topdelete = { text = ThisNvimConfig.icons.git.TopDelete },
				changedelete = { text = ThisNvimConfig.icons.git.ChangeDelete },
				untracked = { text = ThisNvimConfig.icons.git.Untracked },
			},
			signs_staged = {
				add = { text = ThisNvimConfig.icons.git.Add },
				change = { text = ThisNvimConfig.icons.git.Change },
				delete = { text = ThisNvimConfig.icons.git.Delete },
				topdelete = { text = ThisNvimConfig.icons.git.TopDelete },
				changedelete = { text = ThisNvimConfig.icons.git.ChangeDelete },
				untracked = { text = ThisNvimConfig.icons.git.Untracked },
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Git: Jump to next [c]hange" })

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Git: Jump to previous [c]hange" })

				-- Actions
				map({ "n", "v" }, "<leader>hs", gitsigns.stage_hunk, { desc = "Git: [s]tage hunk", buffer = bufnr })
				map({ "n", "v" }, "<leader>hr", gitsigns.reset_hunk, { desc = "Git: [r]eset hunk", buffer = bufnr })
				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git: [S]tage file" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git: [R]eset file" })
				map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Git: [u]nstage hunk" })
				map("n", "<leader>hv", gitsigns.preview_hunk_inline, { desc = "Git: pre[v]iew hunk" })

				-- Text object
				map({ "o", "x" }, "ih", ":<c-u>Gitsigns select_hunk<cr>")
			end,
		},

		event = { "BufEnter" },
	},

	{ -- Shareable file links
		-- https://github.com/ruifm/gitlinker.nvim
		"ruifm/gitlinker.nvim",
		config = function()
			local gitlinker = require("gitlinker")
			local actions = require("gitlinker.actions")
			local hosts = require("gitlinker.hosts")

			gitlinker.setup({
				mappings = "<leader>hy",
				opts = {
					remote = nil,
					add_current_line_on_normal_mode = true,
					action_callback = actions.copy_to_clipboard,
					print_url = true,
				},
				callbacks = {
					["github.com"] = hosts.get_github_type_url,
					["gitlab.com"] = hosts.get_gitlab_type_url,
					["try.gitea.io"] = hosts.get_gitea_type_url,
					["codeberg.org"] = hosts.get_gitea_type_url,
					["bitbucket.org"] = hosts.get_bitbucket_type_url,
					["try.gogs.io"] = hosts.get_gogs_type_url,
					["git.sr.ht"] = hosts.get_srht_type_url,
					["git.launchpad.net"] = hosts.get_launchpad_type_url,
					["repo.or.cz"] = hosts.get_repoorcz_type_url,
					["git.kernel.org"] = hosts.get_cgit_type_url,
					["git.savannah.gnu.org"] = hosts.get_cgit_type_url,
				},
			})
		end,

		event = { "BufEnter" },
	},
}
