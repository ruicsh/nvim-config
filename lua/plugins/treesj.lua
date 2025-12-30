-- Splitting/joining blocks of code.
-- https://github.com/Wansmer/treesj

return {
	"Wansmer/treesj",
	keys = {
		{ "<leader>j", "<cmd>TSJToggle<cr>", desc = "Toggle split/join" },
	},
	opts = {
		max_join_length = 100000000, -- No limit
		use_default_keymaps = false,
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
}
