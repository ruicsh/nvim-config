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

		event = { "BufReadPost", "BufNewFile" },
	},

	{ -- Repeat plugin keymaps (vim-repeat).
		-- https://github.com/tpope/vim-repeat
		"tpope/vim-repeat",

		event = { "BufReadPost", "BufNewFile" },
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

		cmd = "Sort",
	},

	{ -- Surrounding delimiter pairs (nvim-surround).
		-- https://github.com/kylechui/nvim-surround
		"kylechui/nvim-surround",
		config = true,

		event = { "BufReadPost", "BufNewFile" },
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

		event = { "BufReadPost", "BufNewFile" },
	},

	{ -- Use jj to escape (better-escape.nvim).
		-- https://github.com/max397574/better-escape.nvim
		"max397574/better-escape.nvim",
		config = true,

		event = { "VimEnter" },
	},

	{ -- Various text objects (nvim-various-textobjs).
		-- https://github.com/chrisgrieser/nvim-various-textobjs
		"chrisgrieser/nvim-various-textobjs",
		opts = {
			useDefaultKeymaps = true,
		},
		config = function()
			vim.keymap.set({ "o", "x" }, "ab", "<cmd>lua require('various-textobjs').anyBracket('outer')<cr>")
			vim.keymap.set({ "o", "x" }, "ib", "<cmd>lua require('various-textobjs').anyBracket('inner')<cr>")
		end,

		event = { "BufReadPost", "BufNewFile" },
	},

	{ -- Yank history (yanky.nvim).
		-- https://github.com/gbprod/yanky.nvim
		"gbprod/yanky.nvim",
		keys = {
			{ "p", "<Plug>(YankyPutAfter)", { mode = { "n", "x" } } },
			{ "P", "<Plug>(YankyPutBefore)", { mode = { "n", "x" } } },
			{ "gp", "<Plug>(YankyGPutAfter)", { mode = { "n", "x" } } },
			{ "gP", "<Plug>(YankyGPutBefore)", { mode = { "n", "x" } } },
			{ "P", "<Plug>(YankyPutBefore)", { mode = { "n", "x" } } },
			{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", { mode = "n" } },
			{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { mode = "n" } },

			{ "<c-p>", "<Plug>(YankyPreviousEntry)", { mode = "n" } },
			{ "<c-n>", "<Plug>(YankyNextEntry)", { mode = "n" } },
		},
		opts = {
			highlight = {
				timer = 200,
			},
		},

		event = { "BufReadPost", "BufNewFile" },
	},
}
