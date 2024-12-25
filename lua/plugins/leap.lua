-- Jump with search labels
-- https://github.com/ggandor/leap.nvim

return {
	"ggandor/leap.nvim",
	keys = function()
		local mappings = {
			{ "s", "<Plug>(leap)", "Search" },
			{ "S", "<Plug>(leap-from-window)", "Search on windows" },
			{ "s", "<Plug>(leap-forward)", "Forward", { modes = { "x", "o" } } },
			{ "S", "<Plug>(leap-backward)", "Backward", { modes = { "x", "o" } } },
		}
		return vim.fn.getlazykeysconf(mappings, "Leap")
	end,

	events = { "VeryLazy" },
	dependencies = {
		"tpope/vim-repeat",
	},
}
