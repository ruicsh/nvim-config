local M = {}

M = {
	diagnostics = {
		error = "E",
		warning = "W",
		information = "I",
		hint = "H",
	},
	git = {
		Add = "┃",
		Change = "┋",
		ChangeDelete = "┃",
		Delete = "",
		TopDelete = "",
		Untracked = "┃",
		add = "+",
		branch = "",
		change = "~",
		commit = "",
		delete = "-",
	},
	spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
}

return M
