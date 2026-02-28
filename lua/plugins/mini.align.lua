-- Align text interactively
-- https://github.com/nvim-mini/mini.align

return {
	"nvim-mini/mini.align",
	opts = {
		mappings = {
			start = "ga",
			start_with_preview = "gA",
		},
	},

	keys = {
		{ "ga", mode = { "n", "v" }, desc = "Align" },
		{ "gA", mode = { "n", "v" }, desc = "Align (preview)" },
	},
}
