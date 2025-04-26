-- Pickers.
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

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

local function bookmarks()
	local snacks = require("snacks")
	return snacks.picker.marks({ filter_marks = "A-I" })
end

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local mappings = {
			-- search
			{ "<leader><space>", snacks.picker.smart, "Search: Files" },
			{ "<leader>/", snacks.picker.grep, "Search: Workspace" },
			{ "<leader>?", grep_directory, "Search: Directory" },
			{ "<leader>*", snacks.picker.grep_word, "Search: Current word" },

			-- current state
			{ "<leader>'", bookmarks, "Bookmarks" },
			{ "<leader>,", snacks.picker.buffers, "Buffers" },
			{ "<leader>.", snacks.picker.resume, "Recent buffers" },
			{ "<leader>:", snacks.picker.command_history, "Command history" },
			{ "<leader>jj", snacks.picker.jumps, "Jumplist" },
			{ "<leader>mm", snacks.picker.marks, "Marks" },
			{ "<leader>pp", snacks.picker.projects, "Projects" },
			{ "<leader>qq", snacks.picker.qflist, "Quickfix" },
			{ "<leader>uu", snacks.picker.undo, "Undotree" },

			-- neovim
			{ "<leader>nh", snacks.picker.help, "Help" },
			{ "<leader>na", snacks.picker.autocmds, "Autocmds" },
			{ "<leader>nc", snacks.picker.commands, "Commands" },
			{ "<leader>nH", snacks.picker.highlights, "Highlights" },
			{ "<leader>nk", snacks.picker.keymaps, "Keymaps" },
			{ "<leader>no", snacks.picker.notifications, "Notifications" },
		}

		return vim.fn.get_lazy_keys_conf(mappings)
	end)(),
	opts = {
		picker = {
			enabled = true,
			formatters = {
				file = {
					filename_first = true,
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
				marks = {
					transform = function(item, ctx)
						local init_opts = ctx.picker.init_opts or {}
						-- Only show bookmarks [A-I]
						if init_opts.filter_marks == "A-I" then
							return item.label and item.label:match("^[A-I]$") and true or false
						end

						return true
					end,
					format = function(item, picker)
						local init_opts = picker.init_opts or {}
						local ret = {}

						if item.label then
							local label = item.label
							-- Show the label as a number
							if init_opts.filter_marks == "A-I" then
								label = "" .. string.byte(item.label) - string.byte("A") + 1 .. ""
							end
							ret[#ret + 1] = { label, "SnacksPickerLabel" }
							ret[#ret + 1] = { " ", virtual = true }
						end

						local path = Snacks.picker.util.path(item) or item.file
						local dir, base = path:match("^(.*)/(.+)$")
						local base_hl = item.dir and "SnacksPickerDirectory" or "SnacksPickerFile"
						local dir_hl = "SnacksPickerDir"

						-- Get the current working directory
						local cwd = vim.fn.getcwd() .. "/"
						-- Make dir relative to cwd if it starts with cwd
						if dir and dir:sub(1, #cwd) == cwd then
							dir = dir:sub(#cwd + 1)
						end

						ret[#ret + 1] = { base, base_hl, field = "file" }
						ret[#ret + 1] = { " " }
						ret[#ret + 1] = { dir, dir_hl, field = "file" }

						return ret
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
					win = {
						input = {
							keys = {
								["<c-e>"] = { "close", mode = { "n", "i" } },
							},
						},
					},
				},
			},
			ui_select = true,
			win = {
				input = {
					keys = {
						["<c-e>"] = { "close", mode = { "n", "i" } },
						["<c-m>"] = { "flash", mode = { "n", "i" } },
						["<cr>"] = { "confirm", mode = { "n", "i" } },
						["<c-y>"] = { "confirm", mode = { "n", "i" } },
						["m"] = { "flash" },
						["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
						["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
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
