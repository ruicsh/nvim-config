-- Text edit operators
-- https://github.com/echasnovski/mini.operators

return {
	"echasnovski/mini.operators",
	opts = {
		exchange = {
			prefix = "",
		},
		multiply = {
			prefix = "<leader>m",
		},
		replace = {
			prefix = "<leader>r",
		},
		sort = {
			prefix = "<leader>s",
		},
	},

	event = "BufRead",
}
