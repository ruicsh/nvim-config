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
}

--
local function set_keymaps_navigation()
	local nav = require("nvim-treesitter-refactor.navigation")

	local function goto_next_usage()
		nav.goto_next_usage(vim.api.nvim_get_current_buf())
	end

	local function goto_prev_usage()
		nav.goto_previous_usage(vim.api.nvim_get_current_buf())
	end

	vim.keymap.set("n", "]r", goto_next_usage, { desc = "Next diff hunk" })
	vim.keymap.set("n", "[r", goto_prev_usage, { desc = "Previous diff hunk" })
end

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
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<leader>v",
					node_incremental = ";",
					node_decremental = ",",
					scope_incremental = false,
				},
			},
			indent = {
				enable = true,
			},
			refactor = {
				navigation = {
					enable = true,
					keymaps = {
						goto_definition = false,
						list_definitions = false,
						list_definitions_toc = false,
						goto_next_usage = false,
						goto_previous_usage = false,
					},
				},
			},
		}
	end,
	config = function(_, opts)
		local ts = require("nvim-treesitter.configs")
		ts.setup(opts)

		set_keymaps_navigation()
	end,

	main = "nvim-treesitter.configs",
	build = ":TSUpdate",
	event = "BufReadPost",
	dependencies = {
		{ -- Syntax aware text objects.
			-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		{ -- AST navigation
			-- https://github.com/nvim-treesitter/nvim-treesitter-refactor
			"nvim-treesitter/nvim-treesitter-refactor",
		},
	},
}
