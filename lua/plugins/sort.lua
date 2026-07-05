-- Sort lines, selections, or text objects
-- https://github.com/sQVe/sort.nvim

return {
	"sQVe/sort.nvim",
	keys = {
		{ "<leader>ss", "<leader>s<leader>s", desc = "Sort Line", remap = true },
	},
	opts = {
		ignore_case = true,
		mappings = {
			motion = false,
			operator = "<leader>s",
			textobject = false,
		},
	},
	config = function(_, opts)
		require("sort").setup(opts)
	end,
}
