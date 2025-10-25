-- Toggle boolean values with <C-a> and <C-x>
-- https://github.com/nat-418/boole.nvim

return {
	"nat-418/boole.nvim",
	opts = {
		mappings = {
			increment = "<C-a>",
			decrement = "<C-x>",
		},
	},
}
