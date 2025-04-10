local M = {}

M = {
	diagnostics = {
		error = "",
		warning = "",
		information = "",
		hint = "",
	},
	git = {
		added = "",
		changed = "",
		removed = "",
		Add = "┃",
		Change = "┋",
		Delete = "",
		TopDelete = "",
		ChangeDelete = "┃",
		Untracked = "┃",
	},
	spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
	dap = {
		Stopped = " ",
		Breakpoint = " ",
	},
}

return M
