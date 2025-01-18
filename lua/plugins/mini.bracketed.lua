-- Go forward/backward with square brackets.
-- https://github.com/echasnovski/mini.bracketed

return {
	"echasnovski/mini.bracketed",
	opts = {
		buffer = { suffix = "" },
		comment = { suffix = "" },
		conflict = { suffix = "" },
		diagnostic = { suffix = "d" }, -- FIXME: will be default in v0.11
		file = { suffix = "" },
		indent = { suffix = "" },
		jump = { suffix = "j" },
		location = { suffix = "l" }, -- FIXME: will be default in v0.11
		oldfile = { suffix = "" },
		quickfix = { suffix = "q" }, -- FIXME: will be default in v0.11
		treesitter = { suffix = "" },
		undo = { suffix = "" },
		window = { suffix = "" },
		yank = { suffix = "y" },
	},

	event = { "VeryLazy" },
}
