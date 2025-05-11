-- Code parser
-- https://github.com/nvim-treesitter/nvim-treesitter

return {
	"nvim-treesitter/nvim-treesitter",
	opts = function()
		return {
			auto_install = true, -- Auto-install languages that are not installed
			-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
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
				"python",
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
			highlight = {
				enable = true,
				disable = function(_, buf)
					local max_filesize = 1024 * 1024 -- 1 Mb threshold
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end

					return false
				end,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<leader>v",
					node_incremental = "<c-a>",
					node_decremental = "<c-x>",
					scope_incremental = false,
				},
			},
			indent = {
				enable = true,
			},
		}
	end,

	main = "nvim-treesitter.configs",
	build = ":TSUpdate",
	event = "BufReadPost",
	dependencies = {
		{ -- Syntax aware text objects.
			-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},
}
