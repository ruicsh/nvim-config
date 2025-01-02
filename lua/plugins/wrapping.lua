-- Toggle soft/hard wrap
-- https://github.com/andrewferrier/wrapping.nvim

return {
	"andrewferrier/wrapping.nvim",
	keys = function()
		local wrapping = require("wrapping")

		local mappings = {
			{ "[ow", wrapping.soft_wrap_mode, "Soft wrap" },
			{ "]ow", wrapping.hard_wrap_mode, "Hard wrap" },
			{ "<leader>ow", wrapping.toggle_wrap_mode, "Toggle wrap" },
		}

		return vim.fn.getlazykeysconf(mappings, "Wrapping")
	end,
	opts = {
		create_commands = false,
		create_keymaps = false,
		notify_on_switch = false,
	},

	event = { "VeryLazy" },
}
