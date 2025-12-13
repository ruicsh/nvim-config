-- Improved Yank and Put actions
-- https://github.com/gbprod/yanky.nvim

return {
	"gbprod/yanky.nvim",
	keys = function()
		local mappings = {
			{ "<leader>p", ":lua Snacks.picker.yanky()<cr>", "History", mode = { "n", "x" } },
			{ "y", "<Plug>(YankyYank)", "Yank", { mode = { "n", "x" } } },
			{ "p", "<Plug>(YankyPutAfter)", "Put after", { mode = { "n", "x" } } },
			{ "<c-v>", "<Plug>(YankyPutAfter)", "Put after", { mode = { "n", "x" } } },
			{ "P", "<Plug>(YankyPutBefore)", "Put before", { mode = { "n", "x" } } },
			{ "<c-p>", "<Plug>(YankyPreviousEntry)", "Select previous" },
			{ "<c-n>", "<Plug>(YankyNextEntry)", "Select next" },
			{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", "Put after (linewise)" },
			{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", "Put before (linewise)" },
			{ "]P", "<Plug>(YankyPutIndentAfterLinewise)", "Put after (linewise)" },
			{ "[P", "<Plug>(YankyPutIndentBeforeLinewise)", "Put before (linewise)" },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Yanky")
	end,
	opts = {
		highlight = {
			timer = 200,
		},
	},

	dependencies = {
		"folke/snacks.nvim",
	},
}
