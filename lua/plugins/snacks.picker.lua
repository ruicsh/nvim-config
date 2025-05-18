-- Pickers.
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

local icons = require("config/icons")

-- Open a ui.select to search for a directory to search in
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

-- Get the project directories from the environment variable
local function get_project_dirs()
	vim.fn.load_env_file() -- Make sure the env file is loaded

	local project_dirs = {}
	local project_dirs_env = vim.fn.getenv("PROJECTS_DIRS")
	if project_dirs_env ~= vim.NIL and project_dirs_env ~= "" then
		project_dirs = vim.split(project_dirs_env, ",")
	end

	return project_dirs
end

-- Common layout used by git_log and git_log_file
local git_log_layout = {
	layout = {
		backdrop = false,
		width = 0.8,
		height = 0.9,
		box = "vertical",
		border = "single",
		title = "{title} {live} {flags}",
		title_pos = "center",
		{ win = "input", height = 1, border = "bottom" },
		{ win = "list", height = 5, border = "none" },
		{ win = "preview", height = 0.8, border = "top" },
	},
}

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local mappings = {
			-- files
			{ "<leader><space>", snacks.picker.smart, "Files" },
			{ "<leader>-", snacks.picker.projects, "Workspaces" },
			{ "<leader>,", snacks.picker.buffers, "Buffers" },

			-- search
			{ "<leader>/", snacks.picker.grep, "Search: Workspace" },
			{ "<leader>?", grep_directory, "Search: Directory" },
			{ "<leader>*", snacks.picker.grep_word, "Search: Current word" },
			{ "<leader>sh", snacks.picker.search_history, "Search: History" },

			-- current state
			{ "<leader>'", snacks.picker.marks, "Marks" },
			{ "<leader>.", snacks.picker.resume, "Last picker" },
			{ "<leader>:", snacks.picker.command_history, "Command history" },
			{ '<leader>"', snacks.picker.registers, "Command history" },
			{ "<leader>jj", snacks.picker.jumps, "Jumplist" },
			{ "<leader>qq", snacks.picker.qflist, "Quickfix" },
			{ "<leader>uu", snacks.picker.undo, "Undotree" },

			-- git
			{ "<leader>hbr", snacks.picker.git_branches, "Git: Branches" },
			{ "<leader>hlf", snacks.picker.git_log_file, "Git: Log file" },
			{ "<leader>hlg", snacks.picker.git_log, "Git: Log" },
			{ "<leader>hll", snacks.picker.git_log_line, "Git: Log line" },
			{ "<leader>hst", snacks.picker.git_status, "Git: Status" },

			-- neovim
			{ "<leader>nH", snacks.picker.highlights, "Highlights" },
			{ "<leader>na", snacks.picker.autocmds, "Autocmds" },
			{ "<leader>nc", snacks.picker.commands, "Commands" },
			{ "<leader>nh", snacks.picker.help, "Help" },
			{ "<leader>nk", snacks.picker.keymaps, "Keymaps" },
		}

		return vim.fn.get_lazy_keys_conf(mappings)
	end)(),
	opts = {
		picker = {
			actions = {
				send_to_qflist = function(picker)
					picker:close()
					local qflist = {}
					for _, item in ipairs(picker:items()) do
						if item.file then
							table.insert(qflist, {
								lnum = item.pos[1],
								col = item.pos[2],
								text = item.line,
								filename = item.file,
							})
						end
					end
					vim.fn.setqflist({}, "r", { items = qflist })
					require("snacks.picker").qflist()
				end,
			},
			enabled = true,
			formatters = {
				file = {
					filename_first = true,
				},
			},
			icons = {
				diagnostics = {
					Error = icons.diagnostics.error,
					Warn = icons.diagnostics.warning,
					Info = icons.diagnostics.information,
					Hint = icons.diagnostics.hint,
				},
			},
			matcher = {
				cwd_bonus = true,
				frecency = true,
				history_bonus = true,
			},
			sources = {
				buffers = {
					layout = {
						preview = false,
						preset = "vertical",
					},
					on_show = function()
						vim.cmd.stopinsert() -- start in normal mode
					end,
					sort_lastused = true,
					win = {
						list = {
							keys = {
								["<c-x>"] = { "bufdelete" },
							},
						},
					},
				},
				command_history = {
					layout = {
						preview = false,
						preset = "vertical",
					},
				},
				commands = {
					layout = {
						preview = false,
						preset = "vertical",
					},
				},
				files = {
					hidden = true,
				},
				git_log = {
					layout = git_log_layout,
				},
				git_log_file = {
					layout = git_log_layout,
				},
				git_log_line = {
					layout = git_log_layout,
				},
				grep = {
					exclude = { "package-lock.json", "lazy-lock.json" },
				},
				help = {
					confirm = function(picker, item)
						picker:close()
						vim.cmd("only")
						vim.cmd("vertical help " .. item.tag)
					end,
				},
				projects = {
					dev = get_project_dirs(),
					confirm = function(picker, item)
						picker:close()
						if not item or not item.file then
							vim.notify("No project selected", "WARN")
							return
						end

						-- Check if the project is already open by checking the cwd of each tab
						local tabpages = vim.api.nvim_list_tabpages()
						for _, tabpage in ipairs(tabpages) do
							local tab_cwd = vim.fn.getcwd(-1, tabpage)
							if tab_cwd == item.file then
								-- Change to the tab
								vim.api.nvim_set_current_tabpage(tabpage)
								return
							end
						end

						-- If there are already opened buffers, open a new tab
						for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
							if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) ~= "" then
								vim.cmd("tabnew")
								break
							end
						end

						-- Change cwd to the selected project, only for this tab
						vim.cmd("tcd " .. vim.fn.fnameescape(item.file))
						vim.cmd("LoadEnvVars")
						vim.cmd("RestoreChangedFiles")
					end,
					layout = {
						preview = false,
						preset = "vertical",
					},
				},
				registers = {
					layout = {
						preview = false,
						preset = "vertical",
					},
				},
				search_history = {
					layout = {
						preview = false,
						preset = "vertical",
					},
				},
			},
			ui_select = true,
			win = {
				input = {
					keys = {
						["<c-q>"] = { "send_to_qflist", mode = { "n", "i" } },
						["<esc>"] = { "close", mode = { "n", "i" } },
					},
				},
			},
		},
	},

	lazy = false,
	enabled = not vim.g.vscode,
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
	},
}
