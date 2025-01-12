local M = {}

M = {
	diagnostics = {
		error = "",
		warning = "",
		hint = "",
		information = "",
	},
	git = {
		added = "",
		changed = "",
		removed = "",
		Add = "┃",
		Change = "┋",
		Delete = "",
		TopDelete = "",
		ChangeDelete = "┃",
		Untracked = "┃",
	},
}

return M
