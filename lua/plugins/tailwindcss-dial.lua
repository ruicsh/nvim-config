-- Extends dial.nvim to toggle TailwindCSS classes.
-- https://github.com/ruicsh/tailwindcss-dial.nvim

return {
	"ruicsh/tailwindcss-dial.nvim",
	ft = { "astro", "html", "htmlangular", "typescript", "typescriptreact", "javascript", "javascriptreact" }, -- lazy-load trigger
	opts = {
		ft = { "astro", "html", "htmlangular", "typescript", "typescriptreact", "javascript", "javascriptreact" },
	},

	dependencies = { "monaqa/dial.nvim" },
}
