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
			-- pickers
			{ "<leader><space>", snacks.picker.files, "Search: Files" },
			{ "<leader>ff", grep, "Search: Workspace" },
			{ "<leader>fd", search_directory, "Search: Directory" },
			{ "<leader>pp", snacks.picker.projects, "Search: Projects" },
			{ "<leader>,", snacks.picker.buffers, "Search: Buffers" },
			{ "<leader>.", snacks.picker.recent, "Search: Recent" },
			{ "<leader>jj", snacks.picker.jumps, "Search: Jumplist" },
			{ "<leader>gg", snacks.picker.registers, "Search: Registers" },
			{ "<leader>bb", bookmarks, "Search: Bookmarks" },

			-- neovim application
			{ "<leader>nh", snacks.picker.help, "Search: Help" },
			{ "<leader>nc", snacks.picker.commands, "Search: Commands" },
			{ "<leader>nk", snacks.picker.keymaps, "Search: Keymaps" },
			{ "<leader>na", snacks.picker.autocmds, "Search: autocmds" },

			{ "<leader>uu", snacks.picker.undo, "Undo: Tree" },
			{ "<leader>oo", snacks.notifier.show_history, "Notifications: Show history" },
		}

		return vim.fn.get_lazy_keys_conf(mappings)
	end)(),
	opts = {
		picker = {
			enabled = true,
			actions = {
				flash = function(picker)
					require("flash").jump({
						pattern = "^",
						label = { after = { 0, 0 } },
						search = {
							mode = "search",
							exclude = {
								function(win)
									return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
								end,
							},
						},
						action = function(match)
							local idx = picker.list:row2idx(match.pos[1])
							picker.list:_move(idx, true, true)
						end,
					})
				end,
			},
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
