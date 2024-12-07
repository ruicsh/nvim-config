-- Status line
-- https://github.com/nvim-lualine/lualine.nvim

local config = require("ruicsh")

return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local git_blame = require("gitblame")
		vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text.

		local lualine = require("lualine")
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

		lualine.setup({
			options = {
				theme = theme,
				component_separators = "",
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return " " .. str
						end,
					},
				},
				lualine_b = { workspaces.name },
				lualine_c = {
					{
						"filename",
						path = 4,
					},
					{
						"filetype",
						icon_only = true,
						icon = { align = "right" },
					},
					{
						"diagnostics",
						symbols = {
							error = config.icons.diagnostics.Error,
							warn = config.icons.diagnostics.Warn,
							info = config.icons.diagnostics.Info,
							hint = config.icons.diagnostics.Hint,
						},
					},
				},
				lualine_x = {
					{
						git_blame.get_current_blame_text,
						cond = git_blame.is_blame_text_available,
					},
				},
				lualine_y = {
					{
						"diff",
						symbols = {
							added = config.icons.git.added,
							modified = config.icons.git.modified,
							removed = config.icons.git.removed,
						},
					},
				},
				lualine_z = {
					"branch",
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			extensions = {
				"aerial",
				"fugitive",
				"lazy",
				"man",
				"mason",
				"neo-tree",
				"nvim-dap-ui",
				"oil",
				"quickfix",
				"toggleterm",
			},
		})
	end,

	event = { "VimEnter" },
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}
