--
-- User interface
--

local g = require("ruicsh/plugins/globals")

return {
	{ -- load env variables from a .env file (dotenv)
		-- https://github.com/ellisonleao/dotenv.nvim
		"ellisonleao/dotenv.nvim",
		config = function()
			local dotenv = require("dotenv")
			dotenv.setup()

			local init = vim.fn.expand(vim.env.MYVIMRC)
			local path = vim.uv.fs_realpath(init)
			local dir = vim.fs.dirname(path)
			local file = vim.fs.joinpath(dir, ".env")

			if vim.fn.filereadable(file) then
				vim.cmd(":Dotenv " .. file)
			end
		end,

		event = { "VimEnter" },
	},

	{ -- notifications (fidget.nvim)
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
		ft = g.SourceCodeFiletypes,
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

		event = { "VeryLazy" },
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
			hooks = {
				open = { "Telescope find_files" },
			},
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
					lualine_c = { "diagnostics", "filename", { "filetype", icon_only = true } },
					lualine_x = {
						{ git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
					},
					lualine_y = { "diff" },
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
		ft = g.SourceCodeFiletypes,
	},

	{ -- Folds (nvim-ufo).
		-- https://github.com/kevinhwang91/nvim-ufo
		"kevinhwang91/nvim-ufo",
		opts = {
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
		},

		ft = g.SourceCodeFiletypes,
		dependencies = {
			"kevinhwang91/promise-async",
		},
	},
}
