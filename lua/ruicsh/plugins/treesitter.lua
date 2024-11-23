--
-- Treesitter
--

return {
	{ -- Code parser (nvim-treesitter).
		-- https://github.com/nvim-treesitter/nvim-treesitter
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
			-- Autoinstall languages that are not installed.
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
			auto_tag = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "[n",
					node_incremental = "[n",
					scope_incremental = false,
					node_decremental = "]n",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = {
							query = "@function.outer",
							desc = "Syntax: Select [a] [f]unction",
						},
						["if"] = {
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
						["[f"] = { query = "@function.outer", desc = "Syntax: Previous [f]unction" },
						["[a"] = { query = "@parameter.inner", desc = "Syntax: Previous [a]rgument" },
						["[d"] = { query = "@block.inner", desc = "Syntax: Previous block" },
					},
					goto_previous_end = {
						["[F"] = { query = "@function.outer", desc = "Syntax: Previous [f]unction" },
						["[A"] = { query = "@parameter.inner", desc = "Syntax: Previous [a]rgument" },
						["[D"] = { query = "@block.inner", desc = "Syntax: Previous block" },
					},
					goto_next_start = {
						["]f"] = { query = "@function.outer", desc = "Syntax: Next [f]unction" },
						["]a"] = { query = "@parameter.inner", desc = "Syntax: Next [a]rgument" },
						["]d"] = { query = "@block.inner", desc = "Syntax: Next block" },
					},
					goto_next_end = {
						["]F"] = { query = "@function.outer", desc = "Syntax: Next [f]unction" },
						["]A"] = { query = "@parameter.inner", desc = "Syntax: Next [a]rgument" },
						["]D"] = { query = "@block.inner", desc = "Syntax: Next block" },
					},
				},
			},
		},

		main = "nvim-treesitter.configs",
		event = { "VeryLazy" },
		build = ":TSUpdate",
		dependencies = {
			{ -- Syntax aware text objects.
				-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
				"nvim-treesitter/nvim-treesitter-textobjects",
			},
		},
	},

	{ -- Auto-close/rename html tags (nvim-ts-autotag).
		-- https://github.com/windwp/nvim-ts-autotag
		"windwp/nvim-ts-autotag",
		options = {
			opts = {
				enable_close = true, -- Auto close tags.
				enable_rename = true, -- Auto rename pairs of tags.
				enable_close_on_slash = true, -- Auto close on trailing </.
			},
		},

		main = "nvim-ts-autotag",
		ft = { "html", "htmlangular", "typescript", "typescriptreact", "vue" },
	},

	{ -- Comments on embbeded languages (ex: html inside ts, css inside html) (nvim-ts-context-commentstring).
		-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
		"JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			local comment = require("ts_context_commentstring")
			comment.setup({
				enable_autocmd = false,
				languages = {
					typescript = {
						template_string = "<!-- %s -->", -- angular's inline templates
					},
				},
			})

			local original_get_option = vim.filetype.get_option
			vim.filetype.get_option = function(filetype, option)
				return option == "commentstring"
						and require("ts_context_commentstring.internal").calculate_commentstring()
					or original_get_option(filetype, option)
			end
		end,

		event = { "VeryLazy" },
	},

	{ -- node navigation (tree-climber.nvim)
		-- https://github.com/drybalka/tree-climber.nvim
		"drybalka/tree-climber.nvim",
		keys = function()
			local tc = require("tree-climber")
			return {
				{ "[T", tc.goto_parent, mode = { "n", "v", "o" } },
				{ "]T", tc.goto_child, mode = { "n", "v", "o" } },
				{ "]t", tc.goto_next, mode = { "n", "v", "o" } },
				{ "[t", tc.goto_prev, mode = { "n", "v", "o" } },
			}
		end,
	},
}
