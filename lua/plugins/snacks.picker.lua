-- Pickers.
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

-- Grep for a keyword in the workspace
local function grep()
	return require("snacks").picker.grep({
		exclude = { "package-lock.json", "lazy-lock.json" },
	})
end

-- Open a ui.select to search for a directory to search in
local search_directory = function()
	local snacks = require("snacks")
	local scandir = require("plenary.scandir")

	local cwd = vim.fn.getcwd()
	local dirs = scandir.scan_dir(cwd, {
		only_dirs = true,
		respect_gitignore = true,
	})

	if #dirs == 0 then
		vim.fn.notify("No directories found", "WARN")
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
	})
end

-- Get the project directories from the environment variable
local function get_project_dirs()
	vim.fn.load_env_file() -- make sure the env file is loaded

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
			{ "<leader>/", grep, "Search: Workspace" },
			{ "<leader>?", search_directory, "Search: Directory" },
			{ "<leader>*", snacks.picker.grep_word, "Search: Directory" },

			-- current state
			{ "<leader>'", bookmarks, "Bookmarks" },
			{ "<leader>,", snacks.picker.buffers, "Buffers" },
			{ "<leader>.", snacks.picker.resume, "Recent buffers" },
			{ "<leader>:", snacks.picker.command_history, "Command history" },
			{ "<leader>jj", snacks.picker.jumps, "Jumplist" },
			{ "<leader>mm", snacks.picker.marks, "Marks" },
			{ "<leader>pp", snacks.picker.projects, "Projects" },
			{ "<leader>uu", snacks.picker.undo, "Undotree" },

			-- neovim
			{ "<leader>nH", snacks.picker.highlights, "Highlights" },
			{ "<leader>na", snacks.picker.autocmds, "Autocmds" },
			{ "<leader>nc", snacks.picker.commands, "Commands" },
			{ "<leader>nh", snacks.picker.help, "Help" },
			{ "<leader>nk", snacks.picker.keymaps, "Keymaps" },
			{ "<leader>nn", snacks.picker.notifications, "Notifications" },
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
				frecency = true,
			},
			sources = {
				buffers = {
					sort_lastused = true,
					on_show = function()
						vim.cmd.stopinsert() -- start in normal mode
					end,
				},
				command_history = {
					layout = {
						preview = false,
						preset = "vertical",
					},
				},
				files = {
					hidden = true,
				},
				explorer = {
					layout = {
						preset = "vertical",
					},
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
						if item and item.file then
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
							Snacks.picker.smart()
						end
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
			},
			ui_select = true,
			win = {
				input = {
					keys = {
						["<c-]>"] = { "close", mode = { "n", "i" } },
						["<c-m>"] = { "flash", mode = { "n", "i" } },
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
