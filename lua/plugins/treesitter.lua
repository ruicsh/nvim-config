-- Code parser
-- https://github.com/nvim-treesitter/nvim-treesitter

-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
local PARSERS = {
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
	"http",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"markdown",
	"nginx",
	"nu",
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
}

return {
	"nvim-treesitter/nvim-treesitter",
	opts = function()
		local disabled = vim.fn.env_get_list("TREESITTER_DISABLED_PARSERS")
		local ensure_installed = {}
		for _, parser in ipairs(PARSERS) do
			if not vim.tbl_contains(disabled, parser) then
				table.insert(ensure_installed, parser)
			end
		end

		return {
			auto_install = true, -- Auto-install languages that are not installed
			ensure_installed = ensure_installed,
			highlight = {
				enable = true,
				disable = function(_, buf)
					local max_filesize = 1024 * 1024 -- 1 Mb threshold
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end

					return false
				end,
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
					goto_next_end = {
						["]F"] = "@function.outer",
						["]A"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[A"] = "@parameter.inner",
					},
				},
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
