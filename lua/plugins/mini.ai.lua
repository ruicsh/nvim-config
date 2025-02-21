-- Extend and create a/i textobjects.
-- https://github.com/echasnovski/mini.ai

return {
	"echasnovski/mini.ai",
	opts = function()
		local ai = require("mini.ai")

		return {
			n_lines = 500,
			custom_textobjects = {
				a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }), -- function
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
				g = function()
					local from = { line = 1, col = 1 }
					local to = {
						line = vim.fn.line("$"),
						col = math.max(vim.fn.getline("$"):len(), 1),
					}
					return { from = from, to = to }
				end,
			},
		}
	end,
}
