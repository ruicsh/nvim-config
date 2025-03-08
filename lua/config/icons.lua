local M = {}

M = {
	diagnostics = {
		error = "",
		warning = "",
		information = "",
		hint = "",
	},
	git = {
		add = "",
		change = "",
		delete = "",
		Add = "┃",
		Change = "┋",
		Delete = "",
		TopDelete = "",
		ChangeDelete = "┃",
		Untracked = "┃",
	},
	spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
	dap = {
		Stopped = "󰁕 ",
		Breakpoint = "",
		BreakpointCondition = " ",
		BreakpointRejected = " ",
		LogPoint = ".>",
	},
}

return M
