-- Move by subwords in camelCase
-- https://github.com/chrisgrieser/nvim-spider

return {
	"chrisgrieser/nvim-spider",
	keys = {
		{ "w", ":lua require('spider').motion('w')<cr>" },
		{ "e", ":lua require('spider').motion('e')<cr>" },
		{ "b", ":lua require('spider').motion('b')<cr>" },
		{ "ge", ":lua require('spider').motion('ge')<cr>" },
	},

	event = { "VeryLazy" },
}
