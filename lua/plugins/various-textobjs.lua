-- Various text objects
-- https://github.com/chrisgrieser/nvim-various-textobjs

return {
	"chrisgrieser/nvim-various-textobjs",
	keys = {
		{ "ab", ":lua require('various-textobjs').anyBracket('outer')<cr>", mode = { "o", "x" } },
		{ "ib", ":lua require('various-textobjs').anyBracket('inner')<cr>", mode = { "o", "x" } },
	},
	opts = {
		keymaps = {
			useDefaults = true,
		},
	},

	main = "various-textobjs",
	event = { "VeryLazy" },
}
