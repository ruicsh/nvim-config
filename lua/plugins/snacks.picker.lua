-- Pickers.
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

local search_workspace = function()
	local snacks = require("snacks")
	snacks.picker.grep({ search = vim.fn.expand("<cword>") })
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
				search = vim.fn.expand("<cword>"),
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

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local mappings = {
			-- pickers
			{ "<leader><space>", snacks.picker.files, "Search: Files" },
			{ "<leader>ff", search_workspace, "Search: Workspace" },
			{ "<leader>fd", search_directory, "Search: Directory" },
			{ "<leader>,", snacks.picker.buffers, "Search: Buffers" },
			{ "<leader>ee", snacks.picker.explorer, "Files Tree Explorer" },
			{ "<leader>jj", snacks.picker.jumps, "Search: Jumplist" },

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
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
	},
}
