-- Extend and create a/i textobjects.
-- https://github.com/echasnovski/mini.ai

return {
	"echasnovski/mini.ai",
	opts = function()
		local ai = require("mini.ai")

		return {
			custom_textobjects = {
				a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
				c = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }),
				d = { "%f[%d]%d+" },
				e = function() -- Entire file
					local from = { line = 1, col = 1 }
					local to = {
						line = vim.fn.line("$"),
						col = math.max(vim.fn.getline("$"):len(), 1),
					}
					return { from = from, to = to }
				end,
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
				s = { -- Single words in different cases (camelCase, snake_case, etc.)
					{
						"%u[%l%d]+%f[^%l%d]",
						"%f[^%s%p][%l%d]+%f[^%l%d]",
						"^[%l%d]+%f[^%l%d]",
						"%f[^%s%p][%a%d]+%f[^%a%d]",
						"^[%a%d]+%f[^%a%d]",
					},
					"^().*()$",
				},
			},
			mappings = {
				around = "a",
				inside = "i",

				around_next = "an",
				inside_next = "in",
				around_last = "ap",
				inside_last = "ip",

				goto_left = "g[",
				goto_right = "g]",
			},
			n_lines = 500,
		}
	end,

	event = "BufRead",
}
