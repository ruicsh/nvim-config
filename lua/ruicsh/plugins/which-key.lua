-- Keybindings helper
-- https://github.com/folke/which-key.nvim

return {
	"folke/which-key.nvim",
	opts = {
		preset = "modern",
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},

	event = "VeryLazy",
}
