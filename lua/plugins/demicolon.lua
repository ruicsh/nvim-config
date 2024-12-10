-- Overloaded ; and , keys
-- https://github.com/mawkler/demicolon.nvim

return {
	"mawkler/demicolon.nvim",
	opts = {},

	event = { "VeryLazy" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
}
