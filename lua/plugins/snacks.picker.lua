-- Pickers.
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

local icons = require("core.icons")

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

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local mappings = {
			-- files
			{ "<leader><space>", snacks.picker.smart, "Files" },
			{ "<leader>;", snacks.picker.buffers, "Buffers" },

			-- search
			{ "<leader>/", snacks.picker.grep, "Search: Workspace" },
			{ "<leader>?", grep_directory, "Search: Directory" },
			{ "<leader>g/", snacks.picker.grep_word, "Search: Current word" },
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
			{ "<leader>h/", snacks.picker.git_log, "Git: Search Log" },

			-- neovim
			{ "<leader>nH", snacks.picker.highlights, "Highlights" },
			{ "<leader>na", snacks.picker.autocmds, "Autocmds" },
			{ "<leader>nc", snacks.picker.commands, "Commands" },
			{ "<leader>nh", snacks.picker.help, "Help" },
			{ "<leader>nk", snacks.picker.keymaps, "Keymaps" },
		}

		return vim.fn.get_lazy_keys_conf(mappings)
	end)(),
	priority = 1000, -- Ensure this is loaded before other plugins that might use snacks
	opts = {
		picker = {
			actions = {
				flash = function(picker)
					require("flash").jump({
						pattern = "",
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
			db = { sqlite3_path = vim.fn.env_get("SNACKS_PICKER_DB_SQLITE3_PATH") },
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
			jump = {
				reuse_win = true,
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
					sort_lastused = true,
					win = {
						list = {
							keys = {
								["<c-e>"] = { "bufdelete" },
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
					confirm = function(picker, item)
						picker:close()
						vim.cmd("DiffviewOpen " .. item.commit .. "^!")
					end,
					layout = {
						preset = "vertical",
					},
					title = "Git: Search Log",
				},
				grep = {
					exclude = { "package-lock.json", "lazy-lock.json" },
				},
				help = {
					confirm = function(picker, item)
						picker:close()
						vim.ux.open_on_right_side("vertical help " .. item.tag)
					end,
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
						["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
						["<c-f>"] = { "flash", mode = { "n", "i" } },
						["<c-q>"] = { "close", mode = { "n", "i" } },
						["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
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
