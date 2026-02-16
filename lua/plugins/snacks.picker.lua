-- Pickers.
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

local T = require("lib")

-- Confirm action for git_log pickers
local git_log_on_confirm = function(picker, item)
	picker:close()
	local selected = picker:selected()
	if #selected == 1 then
		vim.cmd("CodeDiff " .. selected[1].commit .. "~1  HEAD")
	elseif #selected > 1 then
		-- If multiple commits are selected, open a diff for the range
		local first = selected[2].commit
		local last = selected[1].commit
		vim.cmd("CodeDiff " .. first .. "~1  " .. last)
	else
		vim.cmd("CodeDiff " .. item.commit .. "~1 " .. item.commit)
	end
end

-- Open picker.select to search for a directory to search in
local grep_directory = function()
	local snacks = require("snacks")
	local has_fd = vim.fn.executable("fd") == 1
	local cwd = vim.fn.getcwd()

	local function show_picker(dirs)
		if #dirs == 0 then
			vim.notify("No directories found", vim.log.levels.WARN)
			return
		end

		local items = {}
		for i, item in ipairs(dirs) do
			table.insert(items, {
				idx = i,
				file = item,
				text = item,
			})
		end

		snacks.picker({
			confirm = function(picker, item)
				picker:close()
				snacks.picker.grep({
					dirs = { item.file },
				})
			end,
			items = items,
			format = function(item, _)
				local file = item.file
				local ret = {}
				local a = Snacks.picker.util.align
				local icon, icon_hl = Snacks.util.icon(file.ft, "directory")
				ret[#ret + 1] = { a(icon, 3), icon_hl }
				ret[#ret + 1] = { " " }
				local path = file:gsub("^" .. vim.pesc(cwd) .. "/", "")
				ret[#ret + 1] = { a(path, 20), "Directory" }

				return ret
			end,
			layout = {
				preview = false,
				preset = "vertical",
			},
			title = "Grep in directory",
		})
	end

	if has_fd then
		local cmd = { "fd", "--type", "directory", "--hidden", "--no-ignore-vcs", "--exclude", ".git" }
		local dirs = {}

		vim.fn.jobstart(cmd, {
			on_stdout = function(_, data, _)
				for _, line in ipairs(data) do
					if line and line ~= "" then
						table.insert(dirs, line)
					end
				end
			end,
			on_exit = function(_, code, _)
				if code == 0 then
					show_picker(dirs)
				else
					-- Fallback to plenary if fd fails
					local fallback_dirs = require("plenary.scandir").scan_dir(cwd, {
						only_dirs = true,
						respect_gitignore = true,
					})
					show_picker(fallback_dirs)
				end
			end,
		})
	else
		-- Use plenary if fd is not available
		local dirs = require("plenary.scandir").scan_dir(cwd, {
			only_dirs = true,
			respect_gitignore = true,
		})
		show_picker(dirs)
	end
end

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")
		local picker = snacks.picker

		return {
			-- files
			{ "<leader><space>", picker.smart, desc = "Files" },
			{ "<leader>,", picker.buffers, desc = "Buffers" },

			-- search
			{ "<leader>/", picker.grep, desc = "Search: Workspace" },
			{ "<leader>?", grep_directory, desc = "Search: Directory" },
			{ "<leader>g/", picker.grep_word, desc = "Search: Current word" },

			-- current state
			{ "<leader>'", picker.marks, desc = "Marks" },
			{ "<leader>.", picker.resume, desc = "Last picker" },
			{ "<leader>;", picker.jumps, desc = "Jumps" },
			{ "<leader>c", picker.qflist, desc = "Quickfix" },
			{ "<leader>u", picker.undo, desc = "Command history" },
			{ '<leader>"', picker.registers, desc = "Registers" },

			-- git
			{ "<leader>h$", picker.git_log_line, desc = "Git: Blame line" },
			{ "<leader>h%", picker.git_log_file, desc = "Git: Log for file" },
			{ "<leader>hb", picker.git_branches, desc = "Git: Branches" },
			{ "<leader>hh", picker.git_status, desc = "Git: Status" },
			{ "<leader>hl", picker.git_log, desc = "Git: Search Log" },

			-- neovim
			{ "<leader>na", picker.autocmds, desc = "Autocmds" },
			{ "<leader>nh", picker.help, desc = "Help" },
			{ "<leader>nH", picker.highlights, desc = "Highlights" },
			{ "<leader>nk", picker.keymaps, desc = "Keymaps" },
		}
	end)(),
	priority = 1000, -- Ensure this is loaded before other plugins that might use snacks
	opts = {
		picker = {
			actions = {
				qflist = function(picker)
					local snacks = require("snacks")
					snacks.picker.actions.qflist(picker)
					vim.cmd("cclose")
					snacks.picker.qflist()
				end,
				qflist_delete_item = function(picker, item)
					if not item or not item.item then
						return
					end

					-- Remove from picker
					picker.finder.items = vim.tbl_filter(function(finder_item)
						return not (
							finder_item.item
							and finder_item.item.bufnr == item.item.bufnr
							and finder_item.item.lnum == item.item.lnum
							and finder_item.item.col == item.item.col
							and finder_item.item.text == item.item.text
						)
					end, picker.finder.items)

					-- Update qflist using picker items
					local new_items = vim.tbl_map(function(finder_item)
						return finder_item.item
					end, picker.finder.items)
					vim.fn.setqflist({}, "r", { items = new_items })

					picker.matcher:run(picker)
				end,
			},
			db = { sqlite3_path = T.env.get("SNACKS_PICKER_DB_SQLITE3_PATH") },
			enabled = true,
			formatters = {
				file = {
					filename_first = true,
				},
			},
			icons = {
				diagnostics = {
					Error = "E",
					Warn = "W",
					Info = "I",
					Hint = "H",
				},
			},
			jump = {
				reuse_win = true,
			},
			layout = "default",
			layouts = {
				default = {
					preview = true,
					layout = {
						backdrop = false,
						border = "rounded",
						box = "vertical",
						height = 0.9,
						title = "{title} {live} {flags}",
						title_pos = "center",
						width = 0.7,
						{ win = "input", height = 1, border = "bottom" },
						{ win = "list", border = "none", height = 0.3 },
						{ win = "preview", title = "{preview}", border = "top" },
					},
				},
				no_preview = {
					preview = false,
					layout = {
						backdrop = false,
						border = "rounded",
						box = "vertical",
						height = 0.9,
						title = "{title}",
						title_pos = "center",
						width = 0.7,
						{ win = "input", height = 1, border = "bottom" },
						{ win = "list", border = "none" },
					},
				},
			},
			matcher = {
				cwd_bonus = true,
				frecency = true,
				history_bonus = true,
			},
			previewers = {
				diff = {
					style = "syntax",
				},
			},
			sources = {
				buffers = {
					filter = {
						filter = function(item)
							return item.name ~= ""
						end,
					},
					format = "file",
					sort_lastused = true,
				},
				git_branches = {
					all = true,
					actions = {
						diff = function(picker, item)
							picker:close()

							-- Open diff for the branch compared to the default branch
							local base = T.git.default_branch()
							vim.cmd("CodeDiff " .. base .. " " .. item.branch)
						end,
						ai_review = function(picker, item)
							picker:close()

							-- Get the git diff for the branch
							local base = T.git.default_branch()
							local ref = string.format("%s...%s", base, item.branch)
							local diff = T.git.diff(ref)
							if diff == "" then
								vim.notify("No changes found in branch " .. item.branch)
								return
							end

							-- Use Copilot Chat to ask for a review of the changes
							local chat = require("CopilotChat")
							local prompt = table.concat({ "> /review", " ", "```diff", diff, "```" }, "\n")
							chat.ask(prompt, {
								model = T.env.get("COPILOT_MODEL_REASON"),
								system_prompt = "/COPILOT_INSTRUCTIONS",
							})
						end,
						toggle_filter = function(picker)
							picker.opts.all = not picker.opts.all
							picker:refresh()
						end,
					},
					format = function(item)
						local a = Snacks.picker.util.align
						local icon = item.current and { a("", 2), "SnacksPickerGitBranchCurrent" } or { a("", 2) }
						local branch = { a(item.branch, 0, { truncate = false }), "SnacksPickerGitBranch" }
						return { icon, branch }
					end,
					win = {
						input = {
							keys = {
								["<cr>"] = { "diff", mode = { "n", "i" } },
								["<c-a>"] = { "toggle_filter", mode = { "n", "i" } },
								["<c-s>"] = { "ai_review", mode = { "n", "i" } },
							},
						},
					},
				},
				git_log = {
					confirm = git_log_on_confirm,
					title = "Git: Search log",
				},
				git_log_file = {
					confirm = git_log_on_confirm,
					title = "Git: Search log for file",
				},
				git_status = {
					win = {
						input = {
							keys = {
								["<tab>"] = false,
								["<c-r>"] = false,
								["<c-s>"] = { "git_stage", mode = { "n", "i" } },
								["<c-x>"] = { "git_restore", mode = { "n", "i" }, nowait = true },
							},
						},
					},
				},
				grep = {
					exclude = T.env.get_list("GREP_EXCLUDE_FILES"),
					hidden = true,
				},
				grep_word = {
					exclude = T.env.get_list("GREP_EXCLUDE_FILES"),
					hidden = true,
				},
				help = {
					confirm = function(picker, item)
						picker:close()
						T.ui.open_side_panel({
							cmd = "help " .. item.tag,
							mode = "replace",
						})
					end,
				},
				lsp_incoming_calls = {
					auto_confirm = false,
				},
				lsp_outgoing_calls = {
					auto_confirm = false,
				},
				qflist = {
					win = {
						input = {
							keys = {
								["<c-x>"] = { "qflist_delete_item", mode = { "n", "i" } },
							},
						},
					},
				},
				registers = {
					layout = "no_preview",
				},
				undo = {
					win = {
						input = {
							keys = {
								["<c-y>"] = { "yank_add", mode = { "n", "i" } },
								["<c-d>"] = { "yank_del", mode = { "n", "i" } },
							},
						},
					},
				},
				yanky = {
					layout = "no_preview",
				},
			},
			ui_select = true,
			win = {
				input = {
					keys = {
						["<esc>"] = { "close", mode = { "n", "i" } },
						["<c-c>"] = { "qflist", mode = { "n", "i" } },
						["<c-d>"] = { "close", mode = { "n", "i" } },
					},
				},
				preview = {
					wo = {
						foldenable = false,
					},
				},
			},
		},
	},

	lazy = false,
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
	},
}
