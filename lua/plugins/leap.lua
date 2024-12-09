-- Jump with search labels
-- https://github.com/ggandor/leap.nvim

return {
	"ggandor/leap.nvim",
	config = function()
		vim.keymap.set("n", "s", "<Plug>(leap)")
		vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
		vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap-forward)")
		vim.keymap.set({ "x", "o" }, "S", "<Plug>(leap-backward)")
	end,

	events = { "VeryLazy" },
	dependencies = {
		"tpope/vim-repeat",
	},
}
