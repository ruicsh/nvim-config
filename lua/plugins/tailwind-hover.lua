-- View all applied tailwindcss values on an element
-- https://github.com/ruicsh/tailwind-hover.nvim

return {
	"ruicsh/tailwind-hover.nvim",
	keys = {
		{ "<s-k>", "<cmd>TailwindHover<cr>", desc = "Tailwind: Hover" },
	},
	opts = {
		fallback_to_lsp_hover = true,
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
}
