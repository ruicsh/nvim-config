-- Notifications.
-- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md

return {
	"folke/snacks.nvim",
	opts = {
		notifier = {
			enabled = true,
			level = vim.log.levels.ERROR,
		},
	},

	event = { "VeryLazy" },
}
