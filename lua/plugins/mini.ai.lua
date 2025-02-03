-- Extend and create a/i textobjects.
-- https://github.com/echasnovski/mini.ai

return {
	"echasnovski/mini.ai",
	opts = function()
		local ai = require("mini.ai")
		return {
			n_lines = 500,
			custom_textobjects = {
				-- arguments
				a = ai.gen_spec.treesitter({
					a = "@parameter.outer",
					i = "@parameter.inner",
				}),
				-- function
				f = ai.gen_spec.treesitter({
					a = "@function.outer",
					i = "@function.inner",
				}),
				-- code block
				o = ai.gen_spec.treesitter({
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}),
			},
		}
	end,

	event = { "VeryLazy" },
}
