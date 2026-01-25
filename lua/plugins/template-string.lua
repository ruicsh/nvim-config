-- Change normal string to template string
-- https://github.com/axelvc/template-string.nvim

return {
	"axelvc/template-string.nvim",
	opts = {
		filetypes = {
			"html",
			"typescript",
			"javascript",
			"typescriptreact",
			"javascriptreact",
			"vue",
			"svelte",
			"python",
			"cs",
		},
		jsx_brackets = true,
		remove_template_string = true,
		restore_quotes = {
			normal = [[']],
			jsx = [["]],
		},
	},
}
