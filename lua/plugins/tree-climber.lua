-- node navigation
-- https://github.com/drybalka/tree-climber.nvim

return {
	"drybalka/tree-climber.nvim",
	keys = function()
		local tc = require("tree-climber")
		return {
			{ "[T", tc.goto_parent, mode = { "n", "v", "o" } },
			{ "]T", tc.goto_child, mode = { "n", "v", "o" } },
			{ "]t", tc.goto_next, mode = { "n", "v", "o" } },
			{ "[t", tc.goto_prev, mode = { "n", "v", "o" } },
		}
	end,

	event = { "VeryLazy" },
}
