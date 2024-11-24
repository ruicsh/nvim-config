--
-- Buffers, splits and tabs management
--

return {
	{ -- Delete buffer (vim-bbye).
		-- https://github.com/moll/vim-bbye
		"moll/vim-bbye",

		cmd = { "Bdelete" },
	},

	{ -- Tab scoping (scope.nvim).
		-- https://github.com/tiagovla/scope.nvim
		"tiagovla/scope.nvim",

		event = { "VimEnter" },
	},

	{ -- Tabs (tabby.nvim).
		-- https://github.com/nanozuki/tabby.nvim
		"nanozuki/tabby.nvim",
		config = function()
			local theme = {
				fill = "TabLineFill",
				head = "TabLine",
				current_tab = "TabLineSel",
				tab = "TabLine",
				win = "TabLine",
				tail = "TabLine",
			}

			local tabby = require("tabby")
			tabby.setup({
				line = function(line)
					return {
						{
							{ "  ", hl = theme.head },
							line.sep("", theme.head, theme.fill),
						},
						line.tabs().foreach(function(tab)
							local hl = tab.is_current() and theme.current_tab or theme.tab
							return {
								line.sep("", hl, theme.fill),
								tab.is_current() and "" or "󰆣",
								tab.number(),
								line.sep("", hl, theme.fill),
								hl = hl,
								margin = " ",
							}
						end),
					}
				end,
			})
		end,

		event = { "VimEnter" },
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},

	{ -- Buffer picker (buffer_manager.nvim).
		-- https://github.com/j-morano/buffer_manager.nvim
		"j-morano/buffer_manager.nvim",
		config = function()
			local bm = require("buffer_manager")
			bm.setup({
				show_indicators = true,
				format_function = function(buf)
					-- display the parent directory name and basename
					local path = vim.fs.dirname(buf)
					local parent = vim.fs.basename(path)
					local basename = vim.fs.basename(buf)
					if parent == "." then
						return basename
					end
					return vim.fs.joinpath(parent, basename)
				end,
				width = 0.5,
			})

			local bmui = require("buffer_manager.ui")
			vim.keymap.set("n", "§", bmui.toggle_quick_menu, { noremap = true, silent = true })
		end,

		event = { "VimEnter" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	{ -- Maximize/restore windows (windows.nvim).
		-- https://github.com/anuvyklack/windows.nvim
		"anuvyklack/windows.nvim",
		keys = {
			{ "<c-w>m", "<cmd>WindowsMaximize<cr>", mode = { "n", "x", "i" }, silent = true },
		},
		opts = {
			animation = {
				enable = false,
			},
		},

		events = { "VeryLazy" },
		dependencies = {
			"anuvyklack/middleclass",
		},
	},

	{ -- Dim inactive windows (vimade).
		-- https://github.com/tadaa/vimade
		"tadaa/vimade",
		opts = {
			fadelevel = 0.6,
		},

		event = { "VeryLazy" },
	},
}
