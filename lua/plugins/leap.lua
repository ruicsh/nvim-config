-- Jump with search labels
-- https://github.com/ggandor/leap.nvim

return {
	"ggandor/leap.nvim",
	config = function()
		local opts = { silent = true, unique = true }

		vim.keymap.set("n", "s", "<Plug>(leap)", opts)
		vim.keymap.set("n", "S", "<Plug>(leap-from-window)", opts)
		vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap-forward)", opts)
		vim.keymap.set({ "x", "o" }, "S", "<Plug>(leap-backward)", opts)
	end,

	events = { "VeryLazy" },
	dependencies = {
		"tpope/vim-repeat",
	},
}
