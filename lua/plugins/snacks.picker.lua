-- Pickesrs.
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

local dirs_to_exclude_from_search = {
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

	local conditions = {}
	local gitignore_dirs = vim.fn.systemlist("git ls-files --others --ignored --exclude-standard --directory")
	for _, dir in ipairs(gitignore_dirs) do
		-- anwywhere in the path
		table.insert(conditions, "-path '*" .. dir .. "*'")
	end
	for _, dir in ipairs(dirs_to_exclude_from_search) do
		-- exclude by name, exact match
		table.insert(conditions, "-name " .. dir)
	end
	local exclude = table.concat(conditions, " -o ")
	local cmd = "find . -type d \\( " .. exclude .. " \\) -prune -o -type d -print | sort"
	local dirs = vim.fn.systemlist(cmd)

	vim.ui.select(dirs, {
		prompt = "Select a directory",
		format_item = function(item)
			return item
		end,
	}, function(choice)
		snacks.picker.grep({ search = vim.fn.expand("<cword>"), dirs = { choice } })
	end)
end

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local mappings = {
			{ "<leader><space>", snacks.picker.files, "Search: Files" },
			{ "<leader>ff", search_workspace, "Search: Workspace" },
			{ "<leader>fd", search_directory, "Search: Directory" },
			{ "<leader>,", snacks.picker.buffers, "Search: Buffers" },
			{ "<leader>j", snacks.picker.jumps, "Search: Jumplist" },
			{ "<leader>nh", snacks.picker.help, "Search: Help" },
			{ "<leader>nc", snacks.picker.commands, "Search: Commands" },
			{ "<leader>nk", snacks.picker.keymaps, "Search: Keymaps" },
			{ "<leader>no", snacks.notifier.show_history, "Notifications: Show history" },
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
			},
		},
	},

	lazy = false,
}
