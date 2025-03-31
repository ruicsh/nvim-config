-- Custom commentstring per language.
-- https://github.com/folke/ts-comments.nvim

return {
	"folke/ts-comments.nvim",
	opts = {
		lang = {
			angular = {
				document = "<!-- %s -->",
			},
			typescript = {
				"// %s",
				"/* %s */",
				document = "<!-- %s ->",
			},
		},
	},

	event = "BufRead",
	enabled = not vim.g.vscode,
}
