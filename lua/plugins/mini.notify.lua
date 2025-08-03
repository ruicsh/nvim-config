-- Notifications.
-- https://github.com/echasnovski/mini.notify

return {
	"echasnovski/mini.notify",
	opts = {
		content = {
			format = nil,
			sort = nil,
		},

		lsp_progress = {
			enable = true,
			duration_last = 3000,
		},

		window = {
			config = {
				border = "single",
			},
			max_width_share = 0.382,
			winblend = 0,
		},
	},

	event = { "VeryLazy" },
}
