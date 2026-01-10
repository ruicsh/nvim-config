-- Conceal long class attributes.
-- https://github.com/razak17/tailwind-fold.nvim

return {
	"razak17/tailwind-fold.nvim",
	opts = {
		highlight = {
			link = "Normal",
		},
	},

	ft = { "html", "svelte", "astro", "vue", "typescriptreact", "php", "blade" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
}
