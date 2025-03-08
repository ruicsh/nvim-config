-- Extend and create a/i textobjects.
-- https://github.com/echasnovski/mini.ai

local ts = require("config/treesitter")

return {
	"echasnovski/mini.ai",
	opts = function()
		local ai = require("mini.ai")

		local scopes_outer = {}
		local scopes_inner = {}
		for _, scope in ipairs(ts.query.scope) do
			table.insert(scopes_outer, scope .. ".outer")
			table.insert(scopes_inner, scope .. ".inner")
		end

		return {
			n_lines = 500,
			custom_textobjects = {
				a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }), -- function
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
				g = function() -- whole file
					local from = { line = 1, col = 1 }
					local to = {
						line = vim.fn.line("$"),
						col = math.max(vim.fn.getline("$"):len(), 1),
					}
					return { from = from, to = to }
				end,
				i = ai.gen_spec.treesitter({ -- scope
					a = scopes_outer,
					i = scopes_inner,
				}),
			},
		}
	end,

	event = "BufRead",
}
