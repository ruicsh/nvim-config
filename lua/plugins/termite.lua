-- Stacking float terminal manager.
-- https://github.com/ruicsh/termite.nvim

return {
	"ruicsh/termite.nvim",
	opts = {
		keymaps = {
			focus_editor = "<c-e>",
			next = "<c-j>",
			prev = "<c-k>",
			toggle = "<s-tab>",
		},
		winbar = false,
	},
}
