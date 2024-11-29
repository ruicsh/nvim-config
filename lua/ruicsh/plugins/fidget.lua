-- Notifications
-- https://github.com/j-hui/fidget.nvim

return {
	"j-hui/fidget.nvim",
	opts = {
		notification = {
			override_vim_notify = true,
			window = {
				winblend = 0,
			},
		},
	},

	event = { "VeryLazy" },
}
