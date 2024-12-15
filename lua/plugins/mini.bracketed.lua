-- Go forward/backward with square brackets.
-- https://github.com/echasnovski/mini.bracketed

return {
	"echasnovski/mini.bracketed",
	opts = {
		buffer = { suffix = "b" },
		diagnostic = { suffix = "d" },
		jump = { suffix = "j" },
		location = { suffix = "l" },
		quickfix = { suffix = "q" },
		treesitter = { suffix = "t" },
		window = { suffix = "w" },
		yank = { suffix = "y" },
	},

	event = { "VeryLazy" },
}
