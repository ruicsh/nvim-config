-- Extends dial.nvim to toggle TailwindCSS classes.
-- https://github.com/ruicsh/tailwindcss-dial.nvim

return {
	"ruicsh/tailwindcss-dial.nvim",
	opts = {
		ft = { "astro", "html", "typescript", "typescriptreact", "javascript", "javascriptreact" },
	},

	dependencies = { "monaqa/dial.nvim" },
	ft = { "astro", "html", "typescript", "typescriptreact", "javascript", "javascriptreact" },
}
