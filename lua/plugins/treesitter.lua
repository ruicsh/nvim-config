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
			disable = function(_, buf)
				local max_filesize = 1024 * 1024 -- 1 MB threshold
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end

				return false
			end,
		},
		indent = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<c-s-left>",
				node_incremental = "<c-s-left>",
				scope_incremental = false,
				node_decremental = "<c-s-right>",
			},
		},
	},

	main = "nvim-treesitter.configs",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		{
			-- Syntax aware text objects.
			-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},
}
