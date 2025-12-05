-- Session management
-- https://github.com/rmagatti/auto-session

return {
	"rmagatti/auto-session",
	opts = {
		close_filetypes_on_save = { "fugitive", "checkhealth", "terminal", "gitcommit" },
		git_auto_restore_on_branch_change = true,
		git_use_branch_name = true,
		purge_after_minutes = 14400,
		suppressed_dirs = { "~/", "~/Downloads", "/" },
	},

	lazy = false,
}
