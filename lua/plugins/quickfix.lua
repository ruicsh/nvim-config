return {
	{
		-- Preview window for quickfix lists
		-- https://github.com/kevinhwang91/nvim-bqf
		"kevinhwang91/nvim-bqf",
		opts = {
			preview = {
				win_height = 25,
				winblend = 0,
			},
		},

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		-- Improved UI and workflow for quickfix and location lists
		-- https://github.com/stevearc/quicker.nvim
		"stevearc/quicker.nvim",
		opts = {
			borders = {
				vert = " ",
			},
			type_icons = {
				E = "E ",
				W = "W ",
				I = "I ",
				N = "N ",
				H = "H ",
			},
		},
		ft = "qf",
	},
}
