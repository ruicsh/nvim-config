--
-- User interface
--

return {
	{ -- Notifications (fidget.nvim)
		-- https://github.com/j-hui/fidget.nvim
		"j-hui/fidget.nvim",
		opts = {
			notification = {
				override_vim_notify = true,
				window = {
					winblend = 0,
				},
			},
		},

		event = { "VeryLazy" },
	},

	{ -- Breadcrumbs (barbecue.nvim)
		-- https://github.com/utilyre/barbecue.nvim
		"utilyre/barbecue.nvim",
		name = "barbecue",
		opts = {
			attach_navic = false,
			theme = {
				normal = { link = "BarbecueNormal" },
				ellipsis = { link = "BarbecueEllipsis" },
				separator = { link = "BarbecueSeparator" },
				basename = { link = "BarbecueBasename" },
				dirname = { link = "BarbecueDirname" },
			},
		},

		cmd = { "Barbecue" },
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
	},

	{ -- Key clues (mini.clue).
		-- https://github.com/echasnovski/mini.clue
		"echasnovski/mini.clue",
		config = function()
			local miniclue = require("mini.clue")
			miniclue.setup({
				triggers = {
					{ mode = "n", keys = "<Leader>" },
					{ mode = "x", keys = "<Leader>" },
					{ mode = "i", keys = "<C-x>" },
					{ mode = "n", keys = "g" },
					{ mode = "x", keys = "g" },
					{ mode = "n", keys = "'" },
					{ mode = "n", keys = "`" },
					{ mode = "x", keys = "'" },
					{ mode = "x", keys = "`" },
					{ mode = "n", keys = '"' },
					{ mode = "x", keys = '"' },
					{ mode = "i", keys = "<C-r>" },
					{ mode = "c", keys = "<C-r>" },
					{ mode = "n", keys = "<C-w>" },
					{ mode = "n", keys = "z" },
					{ mode = "x", keys = "z" },
					{ mode = "n", keys = "[" },
					{ mode = "n", keys = "]" },
				},

				clues = {
					-- Enhance this by adding descriptions for <Leader> mapping groups.
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
				},
			})
		end,

		event = { "VeryLazy" },
	},

	{ -- Command line (wilder.nvim).
		-- https://github.com/gelguy/wilder.nvim
		"gelguy/wilder.nvim",
		keys = {
			":",
			"/",
			"?",
		},
		config = function()
			local wilder = require("wilder")

			wilder.setup({
				modes = { ":", "/", "?" },
			})

			wilder.set_option(
				"renderer",
				wilder.popupmenu_renderer(wilder.popupmenu_palette_theme({
					border = "rounded",
					highlighter = wilder.basic_highlighter(),
					max_height = "50%",
					min_height = 0,
					prompt_position = "bottom",
					reverse = 1,
				}))
			)
		end,
	},

	{ -- Workspaces (workspaces.nvim).
		-- https://github.com/natecraddock/workspaces.nvim
		"natecraddock/workspaces.nvim",
		keys = {
			{ "<leader>pp", "<cmd>Telescope workspaces<cr>", { desc = "Workspaces: List" } },
		},
		opts = {
			cd_type = "tab",
			auto_open = true,
		},

		event = { "VeryLazy" },
	},

	{ -- Terminal (toggleterm.nvim).
		-- https://github.com/akinsho/toggleterm.nvim
		"akinsho/toggleterm.nvim",
		opts = {
			open_mapping = "<c-t>",
			direction = "float",
		},

		event = { "VeryLazy" },
	},

	{ -- Status line (lualine.nvim).
		-- https://github.com/nvim-lualine/lualine.nvim
		"nvim-lualine/lualine.nvim",
		config = function()
			local git_blame = require("gitblame")
			vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text.

			local workspaces = require("workspaces")

			local c = NordStoneColors
			local theme = {
				normal = {
					a = { fg = c.nord1, bg = c.nord8, gui = "bold" },
					b = { fg = c.nord5, bg = c.nord1 },
					c = { fg = c.nord5, bg = "NONE" },
					x = { fg = c.nord3_500, bg = "NONE" },
				},
				insert = {
					a = { fg = c.nord1, bg = c.nord6, gui = "bold" },
				},
				visual = {
					a = { fg = c.nord1, bg = c.nord7, gui = "bold" },
				},
				replace = {
					a = { fg = c.nord1, bg = c.nord13, gui = "bold" },
				},
				inactive = {
					a = { fg = c.nord1, bg = c.nord8, gui = "bold" },
					b = { fg = c.nord5, bg = c.nord1 },
					c = { fg = c.nord5, bg = "NONE" },
				},
			}

			local lualine = require("lualine")
			lualine.setup({
				options = {
					theme = theme,
					component_separators = "",
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { workspaces.name },
					lualine_c = {
						{
							"diagnostics",
							symbols = {
								error = ThisNvimConfig.icons.diagnostics.Error,
								warn = ThisNvimConfig.icons.diagnostics.Warn,
								info = ThisNvimConfig.icons.diagnostics.Info,
								hint = ThisNvimConfig.icons.diagnostics.Hint,
							},
						},
						"filename",
						{ "filetype", icon_only = true },
					},
					lualine_x = {
						{ git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
					},
					lualine_y = {
						{
							"diff",
							symbols = {
								added = ThisNvimConfig.icons.git.added,
								modified = ThisNvimConfig.icons.git.modified,
								removed = ThisNvimConfig.icons.git.removed,
							},
						},
					},
					lualine_z = { "branch" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,

		event = { "VimEnter" },
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},

	{ -- Indent guides (indent-blankline.nvim).
		-- https://github.com/lukas-reineke/indent-blankline.nvim
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			scope = {
				show_start = false,
				show_end = false,
			},
		},

		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
	},

	{ -- Better quickfix (nvim-bqf).
		-- https://github.com/kevinhwang91/nvim-bqf
		"kevinhwang91/nvim-bqf",
		config = true,

		event = { "VimEnter" },
	},
}
