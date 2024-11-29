-- Highlight matching words under cursor
-- https://github.com/RRethy/vim-illuminate

return {
	"rrethy/vim-illuminate",
	opts = {
		filetypes_allowlist = {
			"css",
			"dotenv",
			"html",
			"htmlangular",
			"javascript",
			"javascriptreact",
			"json",
			"lua",
			"markdown",
			"typescript",
			"typescriptreact",
		},
		filetypes_denylist = {},
	},
	config = function(_, opts)
		local illuminate = require("illuminate")
		illuminate.configure(opts)
	end,

	event = { "VeryLazy" },
}
