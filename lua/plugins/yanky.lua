-- Improved Yank and Put functionalities
-- https://github.com/gbprod/yanky.nvim

return {
	"gbprod/yanky.nvim",
	keys = function()
		local mappings = {
			{ "<leader>p", ":lua Snacks.picker.yanky()<cr>", "Open Yank History", mode = { "n", "x" } },
			{ "y", "<Plug>(YankyYank)", "Yank text", { mode = { "n", "x" } } },
			{ "p", "<Plug>(YankyPutAfter)", "Put yanked text after cursor", { mode = { "n", "x" } } },
			{ "P", "<Plug>(YankyPutBefore)", "Put yanked text before cursor", { mode = { "n", "x" } } },
			{ "gp", "<Plug>(YankyGPutAfter)", "Put yanked text after selection", { mode = { "n", "x" } } },
			{ "gP", "<Plug>(YankyGPutBefore)", "Put yanked text before selection", { mode = { "n", "x" } } },
			{ "<c-p>", "<Plug>(YankyNextEntry)", "Select previous entry through yank history" },
			{ "<c-n>", "<Plug>(YankyPreviousEntry)", "Select next entry through yank history" },
			{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", "Put indented after cursor (linewise)" },
			{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", "Put indented before cursor (linewise)" },
			{ "]P", "<Plug>(YankyPutIndentAfterLinewise)", "Put indented after cursor (linewise)" },
			{ "[P", "<Plug>(YankyPutIndentBeforeLinewise)", "Put indented before cursor (linewise)" },
			{ ">p", "<Plug>(YankyPutIndentAfterShiftRight)", "Put and indent right" },
			{ "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", "Put and indent left" },
			{ ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", "Put before and indent right" },
			{ "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", "Put before and indent left" },
			{ "=p", "<Plug>(YankyPutAfterFilter)", "Put after applying a filter" },
			{ "=P", "<Plug>(YankyPutBeforeFilter)", "Put before applying a filter" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Yanky")
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
