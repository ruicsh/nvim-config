-- Go forward/backward with square brackets.
-- https://github.com/nvim-mini/mini.bracketed

return {
	"nvim-mini/mini.bracketed",
	opts = {
		buffer = { suffix = "b", options = {} },
		comment = { suffix = "", options = {} },
		conflict = { suffix = "x", options = {} },
		diagnostic = { suffix = "d", options = {} },
		file = { suffix = "", options = {} },
		indent = { suffix = "i", options = {} },
		jump = { suffix = ";", options = {} },
		location = { suffix = "l", options = {} },
		oldfile = { suffix = "o", options = {} },
		quickfix = { suffix = "q", options = {} },
		treesitter = { suffix = "t", options = {} },
		undo = { suffix = "u", options = {} },
		window = { suffix = "w", options = {} },
		yank = { suffix = "y", options = {} },
	},
}
