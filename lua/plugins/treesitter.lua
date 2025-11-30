-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
local LANGUAGES = {
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
	{
		-- AST code parser.
		-- https://github.com/nvim-treesitter/nvim-treesitter
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter").install(LANGUAGES)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter.setup", {}),
				callback = function(args)
					local bufnr = args.buf
					local filetype = args.match

					local language = vim.treesitter.language.get_lang(filetype) or filetype
					if not vim.treesitter.language.add(language) then
						return
					end

					vim.treesitter.start(bufnr, language)
				end,
			})
		end,

		branch = "main",
		build = ":TSUpdate",
	},
	{
		-- Syntax aware text objects.
		-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		"nvim-treesitter/nvim-treesitter-textobjects",
		keys = function()
			local ts_move = require("nvim-treesitter-textobjects.move")

			local function go_to(direction, query)
				return function()
					ts_move["goto_" .. direction .. "_start"](query, "textobjects")
				end
			end

			local mappings = {
				{ "]f", go_to("next", "@function.outer"), "Next function" },
				{ "[f", go_to("previous", "@function.outer"), "Previous function" },
				{ "]a", go_to("next", "@parameter.inner"), "Next parameter" },
				{ "[a", go_to("previous", "@parameter.inner"), "Previous parameter" },
			}

			return vim.fn.get_lazy_keys_conf(mappings, "AST Goto")
		end,
		opts = {
			move = {
				set_jumps = true,
			},
		},

		branch = "main",
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

			local mappings = {
				{ "[s", jump_to_context, "Jump to previous context" },
			}

			return vim.fn.get_lazy_keys_conf(mappings, "AST")
		end,
		opts = {
			separator = "─",
		},

		event = "BufReadPost",
	},
}
