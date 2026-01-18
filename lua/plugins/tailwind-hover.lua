-- View all applied tailwindcss values on an element
-- https://github.com/ruicsh/tailwind-hover.nvim

return {
	"ruicsh/tailwind-hover.nvim",
	keys = {
		{ "<leader><s-k>", "<cmd>TailwindHover<cr>", desc = "Tailwind: Hover" },
	},
	opts = {},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
}
