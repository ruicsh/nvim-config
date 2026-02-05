-- Visualise and resolve merge conflicts
-- https://github.com/akinsho/git-conflict.nvim

return {
	"akinsho/git-conflict.nvim",
	keys = {
		{ "<leader>hX", "<cmd>GitConflictListQf<cr>", desc = "Git: Merge conflicts" },
	},
	opts = {
		list_opener = function()
			local snacks = require("snacks")
			local picker = snacks.picker
			picker.qflist()
		end,
	},

	lazy = false,
}
