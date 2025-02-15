-- Pickers.
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

local DIRS_TO_EXCLUDE_FROM_SEARCH = {
	".git",
	".requests",
	".turbo",
	"__data__",
	"node_modules",
}

local search_workspace = function()
	local snacks = require("snacks")
	snacks.picker.grep({ search = vim.fn.expand("<cword>") })
end

-- Open a ui.select to search for a directory to search in
local search_directory = function()
	local snacks = require("snacks")

	local dirs = {}
	local conditions = {}
	local gitignore_dirs = vim.fn.systemlist("git ls-files --others --ignored --exclude-standard --directory")

	local cmd = ""
	if vim.fn.has("win32") == 1 then
		for _, dir in ipairs(gitignore_dirs) do
			dir = dir:gsub("/", "\\")
			table.insert(conditions, "Not-Match '.+\\" .. dir .. ".*'")
		end
		for _, dir in ipairs(DIRS_TO_EXCLUDE_FROM_SEARCH) do
			dir = dir:gsub("/", "\\")
			table.insert(conditions, "Not-Name '" .. dir .. "'")
		end
		local exclude = table.concat(conditions, " -and ")
		cmd = 'powershell -Command "&{Get-ChildItem -Directory -Recurse | Where-Object {'
			.. exclude
			.. '} | Select-Object -ExpandProperty FullName | ForEach-Object { $_.Substring($pwd.Path.Length + 1) } | Sort-Object}"'
	else
		for _, dir in ipairs(gitignore_dirs) do
			table.insert(conditions, "-path '*" .. dir .. "*'")
		end
		for _, dir in ipairs(DIRS_TO_EXCLUDE_FROM_SEARCH) do
			table.insert(conditions, "-name " .. dir)
		end
		local exclude = table.concat(conditions, " -o ")
		cmd = "find . -type d \\( " .. exclude .. " \\) -prune -o -type d -print | sort"
	end

	dirs = vim.fn.systemlist(cmd)
	if #dirs == 0 then
		vim.fn.notify("No directories found", "WARN")
		return
	end

	snacks.picker({
		finder = function()
			local items = {}
			for i, item in ipairs(dirs) do
				table.insert(items, {
					idx = i,
					file = item,
					text = item,
				})
			end
			return items
		end,
		format = function(item, _)
			local file = item.file
			local ret = {}
			local a = Snacks.picker.util.align
			local icon, icon_hl = Snacks.util.icon(file.ft, "directory")
			ret[#ret + 1] = { a(icon, 3), icon_hl }
			ret[#ret + 1] = { " " }
			ret[#ret + 1] = { a(file, 20) }

			return ret
		end,
		confirm = function(picker, item)
			picker:close()
			snacks.picker.grep({
				search = vim.fn.expand("<cword>"),
				dirs = { item.file },
			})
		end,
	})
end

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local mappings = {
			-- pickers
			{ "<leader><space>", snacks.picker.files, "Search: Files" },
			{ "<leader>ff", search_workspace, "Search: Workspace" },
			{ "<leader>fd", search_directory, "Search: Directory" },
			{ "<leader>/", snacks.picker.buffers, "Search: Buffers" },
			{ "<leader>e", snacks.picker.explorer, "Files Tree Explorer" },
			{ "<leader>j", snacks.picker.jumps, "Search: Jumplist" },

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
		-- https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
		explorer = {
			enabled = true,
		},
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
			win = {
				input = {
					keys = {
						["<c-]>"] = { "close", mode = { "n", "i" } },
						["<c-s>"] = { "flash", mode = { "n", "i" } },
						["s"] = { "flash" },
					},
				},
			},
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
			sources = {
				buffers = {
					sort_lastused = true,
					on_show = function()
						vim.cmd.stopinsert() -- start in normal mode
					end,
				},
				explorer = {
					layout = {
						preset = "vertical",
					},
				},
				help = {
					confirm = function()
						vim.cmd("WindowToggleMaximize forceOpen") -- maximize current window
						vim.cmd("help")
					end,
				},
			},
			ui_select = true,
		},
	},

	lazy = false,
}
