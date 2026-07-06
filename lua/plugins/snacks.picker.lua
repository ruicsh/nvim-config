-- Pickers.
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

local T = require("lib")

local picker = function(name)
	return function()
		require("snacks").picker[name]()
	end
end

local git_log_on_confirm = function(picker, item)
	picker:close()
	local selected = picker:selected()
	require("lazy").load({ plugins = { "codediff.nvim" } })
	local diff = require("codediff.commands").vscode_diff
	if #selected == 1 then
		diff({ fargs = { selected[1].commit .. "~1", "HEAD" } })
	elseif #selected > 1 then
		diff({ fargs = { selected[#selected].commit .. "~1", selected[1].commit } })
	else
		diff({ fargs = { item.commit .. "~1", item.commit } })
	end
end

local grep_opts = { exclude = T.env.get_list("GREP_EXCLUDE_FILES"), hidden = true }
local lsp_calls = { auto_confirm = false }

local function layout_with_preview(preview)
	if preview then
		return {
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
		}
	else
		return {
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
		}
	end
end

local function get_dirs(cwd)
	if vim.fn.executable("fd") == 1 then
		local cmd = { "fd", "--type", "directory", "--hidden", "--no-ignore-vcs", "--exclude", ".git", cwd }
		local result = vim.fn.system(cmd)
		if vim.v.shell_error == 0 then
			local dirs = {}
			for line in vim.gsplit(result, "\n", { trimempty = true }) do
				table.insert(dirs, line)
			end
			if #dirs > 0 then
				return dirs
			end
		end
	end

	return require("plenary.scandir").scan_dir(cwd, {
		only_dirs = true,
		respect_gitignore = true,
	})
end

local grep_directory = function()
	local snacks = require("snacks")
	local cwd = vim.fn.getcwd()
	local dirs = get_dirs(cwd)

	if #dirs == 0 then
		vim.notify("No directories found", vim.log.levels.WARN)
		return
	end

	local items = {}
	for i, item in ipairs(dirs) do
		table.insert(items, { idx = i, file = item, text = item })
	end

	snacks.picker({
		confirm = function(picker, item)
			picker:close()
			snacks.picker.grep({ dirs = { item.file } })
		end,
		items = items,
		format = function(item, _)
			local a = Snacks.picker.util.align
			local icon, icon_hl = Snacks.util.icon(item.file.ft, "directory")
			local path = item.file:gsub("^" .. vim.pesc(cwd) .. "/", "")
			return {
				{ a(icon, 3), icon_hl },
				{ " " },
				{ a(path, 20), "Directory" },
			}
		end,
		layout = { preview = false, preset = "vertical" },
		title = "Grep in directory",
	})
end

return {
	"folke/snacks.nvim",
	keys = {
		{ "<leader><space>", picker("smart"), desc = "Files" },
		{ "<leader>,", picker("buffers"), desc = "Buffers" },

		{ "<leader>/", picker("grep"), desc = "Search: Workspace" },
		{ "<leader>?", grep_directory, desc = "Search: Directory" },
		{ "<leader>g/", picker("grep_word"), desc = "Search: Current word" },

		{ "<leader>'", picker("marks"), desc = "Marks" },
		{ "<leader>.", picker("resume"), desc = "Last picker" },
		{ "<leader>;", picker("jumps"), desc = "Jumps" },
		{ "<leader>u", picker("undo"), desc = "Command history" },
		{ '<leader>"', picker("registers"), desc = "Registers" },

		{ "<leader>hl$", picker("git_log_line"), desc = "Git: Blame line" },
		{ "<leader>hl%", picker("git_log_file"), desc = "Git: Log for file" },
		{ "<leader>hB", picker("git_branches"), desc = "Git: Branches" },
		{ "<leader>hH", picker("git_status"), desc = "Git: Status" },
		{ "<leader>hL", picker("git_log"), desc = "Git: Search Log" },

		{ "<leader>cc", picker("qflist"), desc = "Quickfix List" },

		{ "<leader>na", picker("autocmds"), desc = "Autocmds" },
		{ "<leader>nh", picker("help"), desc = "Help" },
		{ "<leader>nH", picker("highlights"), desc = "Highlights" },
		{ "<leader>nk", picker("keymaps"), desc = "Keymaps" },
	},
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
				default = layout_with_preview(true),
				no_preview = layout_with_preview(false),
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
							require("lazy").load({ plugins = { "codediff.nvim" } })
							require("codediff.commands").vscode_diff({ fargs = { T.git.default_branch(), item.branch } })
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
				grep = grep_opts,
				grep_word = grep_opts,
				help = {
					confirm = function(picker, item)
						picker:close()
						T.ui.open_side_panel({
							cmd = "help " .. item.tag,
							mode = "replace",
						})
					end,
				},
				lsp_incoming_calls = lsp_calls,
				lsp_outgoing_calls = lsp_calls,
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
				scratch = {
					win = {
						input = {
							keys = {
								["<c-n>"] = { "list_down", mode = { "n", "i" } },
							},
						},
					},
				},
				smart = {
					hidden = true,
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

	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
	},
}
