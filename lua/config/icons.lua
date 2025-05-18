local M = {}

M = {
	dap = {
		Stopped = "",
		Breakpoint = "",
	},
	diagnostics = {
		error = "",
		warning = "",
		information = "",
		hint = "",
	},
	git = {
		Add = "┃",
		Change = "┋",
		ChangeDelete = "┃",
		Delete = "",
		TopDelete = "",
		Untracked = "┃",
		add = "",
		branch = "",
		change = "",
		commit = "",
		delete = "",
	},
	spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
}

return M
