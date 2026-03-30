-- Notifications.
-- https://github.com/nvim-mini/mini.notify

return {
	"nvim-mini/mini.notify",
	opts = function()
		local MiniNotify = require("mini.notify")

		return {
			content = {
				format = nil,
				sort = function(notif_arr)
					-- Filter out Pyright LSP progress notifications
					notif_arr = vim.tbl_filter(function(notif)
						return not (
							notif.data
							and notif.data.source == "lsp_progress"
							and notif.data.client_name == "pyright"
						)
					end, notif_arr)
					return MiniNotify.default_sort(notif_arr)
				end,
			},
			lsp_progress = {
				enable = true,
				duration_last = 3000,
			},
			window = {
				config = {
					border = "rounded",
				},
				max_width_share = 0.382,
				winblend = 0,
			},
		}
	end,

	event = { "VeryLazy" },
}
