-- Code parser
-- https://github.com/nvim-treesitter/nvim-treesitter

return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
			"angular",
			"bash",
			"css",
			"csv",
			"diff",
			"dockerfile",
			"embedded_template",
			"git_rebase",
			"gitattributes",
			"gitcommit",
			"gitignore",
			"graphql",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"lua",
			"luadoc",
			"markdown",
			"nginx",
			"powershell",
			"pug",
			"regex",
			"rust",
			"scss",
			"sql",
			"styled",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vue",
			"yaml",
		},
		auto_install = true, -- autoinstall languages that are not installed
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<cr>",
				node_incremental = "<cr>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["a["] = {
						query = "@function.outer",
						desc = "Syntax: Select [a] [f]unction",
					},
					["i["] = {
						query = "@function.inner",
						desc = "Syntax: Select [i]nner [f]unction",
					},
					["aa"] = {
						query = "@paramenter.outer",
						desc = "Syntax: Select [a] [a]rgument",
					},
					["ia"] = {
						query = "@paramenter.inner",
						desc = "Syntax: Select [i]nner [a]rgument",
					},
				},
			},
			move = {
				enable = true,
				set_jumps = false,
				goto_previous_start = {
					["[["] = { query = "@function.outer", desc = "Syntax: Previous [f]unction" },
					["[a"] = { query = "@parameter.inner", desc = "Syntax: Previous [a]rgument" },
				},
				goto_next_start = {
					["]]"] = { query = "@function.outer", desc = "Syntax: Next [f]unction" },
					["]a"] = { query = "@parameter.inner", desc = "Syntax: Next [a]rgument" },
				},
			},
		},
	},

	event = { "BufReadPost", "BufNewFile" },
	main = "nvim-treesitter.configs",
	build = ":TSUpdate",
	dependencies = {
		{
			-- Syntax aware text objects.
			-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},
}
