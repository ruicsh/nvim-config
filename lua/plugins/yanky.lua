-- Improved Yank and Put actions
-- https://github.com/gbprod/yanky.nvim

return {
	"gbprod/yanky.nvim",
	keys = {
		{ "<leader>p", ":lua Snacks.picker.yanky()<cr>", desc = "Clipboard: History", mode = { "n", "x" } },
		{ "y", "<Plug>(YankyYank)", desc = "Clipboard: Yank", mode = { "n", "x" } },
		{ "p", "<Plug>(YankyPutAfter)", desc = "Clipboard: Put after", mode = { "n", "x" } },
		{ "<c-v>", "<Plug>(YankyPutAfter)", desc = "Clipboard: Put after", mode = { "n", "x" } },
		{ "P", "<Plug>(YankyPutBefore)", desc = "Clipboard: Put before", mode = { "n", "x" } },
		{ "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Clipboard: Select previous" },
		{ "<c-n>", "<Plug>(YankyNextEntry)", desc = "Clipboard: Select next" },
		{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Clipboard: Put after (linewise)" },
		{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Clipboard: Put before (linewise)" },
		{ "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Clipboard: Put after (linewise)" },
		{ "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Clipboard: Put before (linewise)" },
	},
	opts = {
		highlight = {
			timer = 200,
		},
	},

	dependencies = {
		"folke/snacks.nvim",
	},
}
