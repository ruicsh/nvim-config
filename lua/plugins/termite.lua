-- Stacking float terminal manager.
-- https://github.com/ruicsh/termite.nvim

return {
	"ruicsh/termite.nvim",
	opts = {
		keymaps = {
			toggle = "<s-tab>",
			next = "<c-j>",
			prev = "<c-k>",
		},
		winbar = false,
	},
}
