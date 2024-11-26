--
-- Text objects, motions and actions
--

return {
	{ -- Move line/selection up/down (mini.move.nvim).
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

		event = { "BufEnter" },
	},

	{ -- Repeat plugin keymaps (vim-repeat).
		-- https://github.com/tpope/vim-repeat
		"tpope/vim-repeat",

		event = { "BufEnter" },
	},

	{ -- Insert mode navigation (vim-rsi).
		-- https://github.com/tpope/vim-rsi
		"tpope/vim-rsi",

		event = { "InsertEnter" },
	},

	{ -- Sort selection (sort.nvim).
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

	{ -- Surrounding delimiter pairs (nvim-surround).
		-- https://github.com/kylechui/nvim-surround
		"kylechui/nvim-surround",
		config = true,

		event = { "BufEnter" },
	},

	{ -- Move by subwords in camelCase (nvim-spider).
		-- https://github.com/chrisgrieser/nvim-spider
		"chrisgrieser/nvim-spider",
		keys = {
			{ "w", "<cmd>lua require('spider').motion('w')<cr>" },
			{ "e", "<cmd>lua require('spider').motion('e')<cr>" },
			{ "b", "<cmd>lua require('spider').motion('b')<cr>" },
			{ "ge", "<cmd>lua require('spider').motion('ge')<cr>" },
		},

		event = { "BufEnter" },
	},

	{ -- Various text objects (nvim-various-textobjs).
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
		event = { "BufEnter" },
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
