-- Extend and create a/i textobjects.
-- https://github.com/nvim-mini/mini.ai

return {
	"nvim-mini/mini.ai",
	opts = function()
		local ai = require("mini.ai")

		return {
			custom_textobjects = {
				["?"] = false,
				["/"] = ai.gen_spec.user_prompt(),
				["%"] = function() -- Entire file
					local from = { line = 1, col = 1 }
					local to = {
						line = vim.fn.line("$"),
						col = math.max(vim.fn.getline("$"):len(), 1),
					}
					return { from = from, to = to }
				end,
				a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
				c = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }),
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

				around_next = "",
				inside_next = "",
				around_last = "",
				inside_last = "",

				goto_left = "",
				goto_right = "",
			},
			n_lines = 500,
		}
	end,

	event = "BufRead",
}
