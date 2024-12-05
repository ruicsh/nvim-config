-- Move by subwords in camelCase
-- https://github.com/chrisgrieser/nvim-spider

return {
	"chrisgrieser/nvim-spider",
	keys = {
		{ "w", "<cmd>lua require('spider').motion('w')<cr>" },
		{ "e", "<cmd>lua require('spider').motion('e')<cr>" },
		{ "b", "<cmd>lua require('spider').motion('b')<cr>" },
		{ "ge", "<cmd>lua require('spider').motion('ge')<cr>" },
	},

	event = { "VeryLazy" },
}
