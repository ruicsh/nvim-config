-- Splitting/joining blocks of code.
-- https://github.com/Wansmer/treesj

return {
	"Wansmer/treesj",
	keys = function()
		local treesj = require("treesj")

		local mappings = {
			{ "<leader>j", treesj.toggle, "Toggle split/join" },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Treesj")
	end,
	opts = {
		use_default_keymaps = false,
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
}
