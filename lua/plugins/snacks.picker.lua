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

local layout = {
	presets = {
		vertical = {
			layout = {
				backdrop = false,
				border = "rounded",
				box = "vertical",
				height = 0.9,
				title = "{title} {live} {flags}",
				title_pos = "center",
				width = 0.7,
				{ win = "input", height = 1, border = "bottom" },
				{ win = "list", border = "none", height = 0.2 },
				{ win = "preview", title = "{preview}", border = "top" },
			},
		},
	},
}

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local mappings = {
			-- files
			{ "<leader><space>", snacks.picker.smart, "Files" },
			{ "<leader>;;", snacks.picker.buffers, "Buffers" },

			-- search
			{ "<leader>/", snacks.picker.grep, "Search: Workspace" },
			{ "<leader>?", grep_directory, "Search: Directory" },
			{ "<leader>g/", snacks.picker.grep_word, "Search: Current word" },

			-- current state
			{ "<leader>'", snacks.picker.marks, "Marks" },
			{ "<leader>.", snacks.picker.resume, "Last picker" },
			{ '<leader>"', snacks.picker.registers, "Command history" },

			-- git
			{ "<leader>h/", snacks.picker.git_log, "Git: Search Log" },

			-- neovim
			{ "<leader>nH", snacks.picker.highlights, "Highlights" },
			{ "<leader>na", snacks.picker.autocmds, "Autocmds" },
			{ "<leader>nh", snacks.picker.help, "Help" },
			{ "<leader>nk", snacks.picker.keymaps, "Keymaps" },
		}

		return vim.fn.get_lazy_keys_conf(mappings)
	end)(),
	priority = 1000, -- Ensure this is loaded before other plugins that might use snacks
	opts = {
		picker = {
			db = { sqlite3_path = vim.fn.env_get("SNACKS_PICKER_DB_SQLITE3_PATH") },
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
				},
				diagnostics = {
					layout = layout.presets.vertical,
				},
				diagnostics_buffer = {
					layout = layout.presets.vertical,
				},
				git_log = {
					confirm = function(picker, item)
						picker:close()
						vim.cmd("DiffviewOpen " .. item.commit .. "^!")
					end,
					layout = layout.presets.vertical,
					title = "Git: Search Log",
				},
				grep = {
					exclude = { "package-lock.json", "lazy-lock.json" },
					hidden = true,
					layout = layout.presets.vertical,
				},
				grep_word = {
					exclude = { "package-lock.json", "lazy-lock.json" },
					layout = layout.presets.vertical,
				},
				help = {
					confirm = function(picker, item)
						picker:close()
						local cmd = vim.ux.is_narrow_screen() and "help" or "vertical help"
						vim.ux.open_side_panel(cmd .. " " .. item.tag)
					end,
				},
				lsp_references = {
					layout = layout.presets.vertical,
				},
				registers = {
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
						["<c-q>"] = { "close", mode = { "n", "i" } },
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
