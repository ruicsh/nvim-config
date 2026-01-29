local T = require("lib")

if T.fn.is_windows() then
	return {}
end

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
	"xml",
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
					-- If it's moving to a function, add jump to jumplist (native behavior).
					if vim.startswith(query, "@function") then
						vim.cmd("normal! m'")
					end
					ts_move["goto_" .. direction .. "_start"](query, "textobjects")
				end
			end

			return {
				{ "]f", go_to("next", "@function.outer"), desc = "AST: Next function" },
				{ "[f", go_to("previous", "@function.outer"), desc = "AST: Previous function" },
				{ "]a", go_to("next", "@parameter.inner"), desc = "AST: Next parameter" },
				{ "[a", go_to("previous", "@parameter.inner"), desc = "AST: Previous parameter" },
				{ "]s", go_to("next", "@css_class_attr_value"), desc = "AST: Next className" },
				{ "[s", go_to("previous", "@css_class_attr_value"), desc = "AST: Previous className" },
			}
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
		opts = {
			max_lines = 3,
			mode = "topline",
			multiwindow = true,
			separator = "─",
		},

		event = "BufReadPost",
	},
}
