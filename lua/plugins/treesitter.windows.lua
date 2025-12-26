local T = require("lib")

if not T.fn.is_windows() then
	return {}
end

-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
local LANGUAGES = {
	"css",
	"diff",
	"embedded_template",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"html",
	"http",
	"javascript",
	"json",
	"lua",
	"luadoc",
	"markdown",
	"nu",
	"powershell",
	"regex",
	"scss",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"yaml",
}

return {
	{
		-- AST code parser
		-- https://github.com/nvim-treesitter/nvim-treesitter
		"nvim-treesitter/nvim-treesitter",
		opts = function()
			return {
				auto_install = true, -- Auto-install languages that are not installed
				ensure_installed = LANGUAGES,
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				textobjects = {
					move = {
						enable = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]a"] = "@parameter.inner",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[a"] = "@parameter.inner",
						},
					},
				},
			}
		end,

		main = "nvim-treesitter.configs",
		branch = "master",
		build = ":TSUpdate",
		lazy = false,
	},
	{
		-- Syntax aware text objects.
		-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		"nvim-treesitter/nvim-treesitter-textobjects",

		branch = "master",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		-- Show code context.
		-- https://github.com/nvim-treesitter/nvim-treesitter-context
		"nvim-treesitter/nvim-treesitter-context",
		keys = function()
			local function jump_to_context()
				require("treesitter-context").go_to_context(vim.v.count1)
			end

			return {
				{ "[s", jump_to_context, desc = "AST: Jump to previous context" },
			}
		end,
		opts = {
			max_lines = 5,
			mode = "topline",
			multiwindow = true,
			separator = "─",
		},
		event = "BufReadPost",
	},
	{
		-- Auto close and rename HTML tags
		-- https://github.com/windwp/nvim-ts-autotag
		"windwp/nvim-ts-autotag",
		opts = {},
	},
}
