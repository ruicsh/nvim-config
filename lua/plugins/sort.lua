-- Sort selection
-- https://github.com/sQVe/sort.nvim

return {
	"sQVe/sort.nvim",
	opts = {
		delimiters = {
			",",
			"|",
			";",
			":",
			"s", -- Space
			"t", -- Tab
		},
	},

	cmd = { "Sort" },
}
