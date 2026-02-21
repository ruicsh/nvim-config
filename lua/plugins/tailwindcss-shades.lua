-- Generate Tailwind CSS color palettes from a single hex color
-- https://github.com/ruicsh/tailwindcss-shades.nvim

return {
	"ruicsh/tailwindcss-shades.nvim",
	keys = {
		{ "<leader>tc", "<cmd>TailwindShadesGenerateCSSVars<cr>", desc = "Tailwind: Shades" },
	},
	opts = {},
}
