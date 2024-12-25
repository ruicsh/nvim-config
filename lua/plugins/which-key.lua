-- Keybindings helper
-- https://github.com/folke/which-key.nvim

return {
	"folke/which-key.nvim",
	keys = function()
		local function show_local_keymaps()
			local wk = require("which-key")
			wk.show({ global = false })
		end
		local mappings = {
			{ "<leader>?", show_local_keymaps, "Buffer local keymaps" },
		}
		return vim.fn.getlazykeysconf(mappings, "WhichKey")
	end,
	opts = {
		preset = "modern",
	},

	event = "VeryLazy",
}
