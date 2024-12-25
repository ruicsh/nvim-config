-- Go forward/backward with square brackets.
-- https://github.com/echasnovski/mini.bracketed

return {
	"echasnovski/mini.bracketed",
	opts = {
		buffer = { suffix = "" },
		comment = { suffix = "" },
		conflict = { suffix = "" },
		diagnostic = { suffix = "d" },
		file = { suffix = "" },
		indent = { suffix = "" },
		jump = { suffix = "j" },
		location = { suffix = "l" },
		oldfile = { suffix = "" },
		quickfix = { suffix = "q" },
		treesitter = { suffix = "t" },
		undo = { suffix = "" },
		window = { suffix = "w" },
		yank = { suffix = "y" },
	},

	event = { "VeryLazy" },
}
