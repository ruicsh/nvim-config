--
-- Text objects, motions and actions
--

return {
	{ -- Move line/selection up/down
		-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-move.md
		"echasnovski/mini.move",
		opts = {
			mappings = {
				down = "]e",
				up = "[e",
				line_up = "[e",
				line_down = "]e",
			},
			options = {
				reindent_linewise = true,
			},
		},

		event = { "VeryLazy" },
	},

	{ -- Repeat plugin keymaps
		-- https://github.com/tpope/vim-repeat
		"tpope/vim-repeat",

		event = { "VeryLazy" },
	},

	{ -- Insert mode navigation
		-- https://github.com/tpope/vim-rsi
		"tpope/vim-rsi",

		event = { "InsertEnter" },
	},

	{ -- Sort selection
		-- https://github.com/sQVe/sort.nvim
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
	},

	{ -- Surrounding delimiter pairs
		-- https://github.com/kylechui/nvim-surround
		"kylechui/nvim-surround",
		config = true,

		event = { "VeryLazy" },
	},

	{ -- Move by subwords in camelCase
		-- https://github.com/chrisgrieser/nvim-spider
		"chrisgrieser/nvim-spider",
		keys = {
			{ "w", "<cmd>lua require('spider').motion('w')<cr>" },
			{ "e", "<cmd>lua require('spider').motion('e')<cr>" },
			{ "b", "<cmd>lua require('spider').motion('b')<cr>" },
			{ "ge", "<cmd>lua require('spider').motion('ge')<cr>" },
		},

		event = { "VeryLazy" },
	},

	{ -- Various text objects
		-- https://github.com/chrisgrieser/nvim-various-textobjs
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
	},

	{ -- Jump with search labels
		-- https://github.com/ggandor/leap.nvim
		"ggandor/leap.nvim",
		config = function()
			vim.keymap.set("n", "s", "<Plug>(leap)")
			vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
			vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap-forward)")
			vim.keymap.set({ "x", "o" }, "S", "<Plug>(leap-backward)")
		end,

		dependencies = {
			"tpope/vim-repeat",
		},
	},
}
