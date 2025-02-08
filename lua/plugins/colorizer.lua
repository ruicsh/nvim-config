-- CSS colors
-- https://github.com/catgoose/nvim-colorizer.lua

return {
	"catgoose/nvim-colorizer.lua",
	opts = {
		filetypes = {
			"css",
			"html",
			"javascript",
			"javascriptreact",
			"jsx",
			"lua",
			"scss",
			"svelte",
			"tsx",
			"typescript",
			"typescriptreact",
			"vue",
		},
	},

	event = { "BufReadPre", "BufNewFile" },
}
