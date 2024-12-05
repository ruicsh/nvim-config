-- Various text objects
-- https://github.com/chrisgrieser/nvim-various-textobjs

return {
	"chrisgrieser/nvim-various-textobjs",
	keys = {
		{ "ab", "<cmd>lua require('various-textobjs').anyBracket('outer')<cr>", mode = { "o", "x" } },
		{ "ib", "<cmd>lua require('various-textobjs').anyBracket('inner')<cr>", mode = { "o", "x" } },
	},
	opts = {
		useDefaultKeymaps = true,
	},

	main = "various-textobjs",
	event = { "VeryLazy" },
}
