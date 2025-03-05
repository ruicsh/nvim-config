-- Code parser
-- https://github.com/nvim-treesitter/nvim-treesitter

local ts = require("config/treesitter")

return {
	"nvim-treesitter/nvim-treesitter",
	opts = function()
		local scopes_outer = {}
		for _, scope in ipairs(ts.query.scope) do
			table.insert(scopes_outer, scope .. ".outer")
		end

		return {
			auto_install = true, -- autoinstall languages that are not installed
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
					local max_filesize = 1024 * 1024 -- 1 MB threshold
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
					init_selection = "<m-s-j>",
					node_incremental = "<m-s-j>",
					scope_incremental = false,
					node_decremental = "<m-s-k>",
				},
			},
			indent = {
				enable = true,
			},
			textobjects = {
				move = {
					enable = true,
					goto_previous_start = { -- beginning of scope
						["[i"] = { query = scopes_outer },
					},
					goto_next_end = { -- end of scope
						["]i"] = { query = scopes_outer },
					},
				},
			},
		}
	end,

	main = "nvim-treesitter.configs",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		{
			-- Syntax aware text objects.
			-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		{
			-- Show code context.
			-- https://github.com/nvim-treesitter/nvim-treesitter-context
			"nvim-treesitter/nvim-treesitter-context",
			keys = function()
				local function jump_to_context()
					require("treesitter-context").go_to_context(vim.v.count1)
				end

				local mappings = {
					{ "[s", jump_to_context, "Jump to previous context" },
				}

				return vim.fn.get_lazy_keys_conf(mappings, "AST")
			end,
			opts = {
				separator = "─",
			},
		},
	},
}
