-- Extend and create a/i textobjects.
-- https://github.com/echasnovski/mini.ai

-- https://github.com/echasnovski/mini.extra/blob/main/lua/mini/extra.lua#L131
local function ai_buffer(ai_type)
	local start_line, end_line = 1, vim.fn.line("$")

	if ai_type == "i" then
		-- Skip first and last blank lines for `i` textobject
		local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
		-- Do nothing for buffer with all blanks
		if first_nonblank == 0 or last_nonblank == 0 then
			return { from = { line = start_line, col = 1 } }
		end
		start_line, end_line = first_nonblank, last_nonblank
	end

	local to_col = math.max(vim.fn.getline(end_line):len(), 1)

	return {
		from = { line = start_line, col = 1 },
		to = { line = end_line, col = to_col },
	}
end

return {
	"echasnovski/mini.ai",
	opts = function()
		local ai = require("mini.ai")

		return {
			n_lines = 500,
			custom_textobjects = {
				a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }), -- function
				c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
				o = ai.gen_spec.treesitter({ -- code block
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}),
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
				g = ai_buffer, -- buffer
			},
		}
	end,

	dependencies = {
		{
			-- Syntax aware text objects.
			-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},
}
