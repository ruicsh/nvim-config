-- Surround actions.
-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md

return {
	"echasnovski/mini.surround",
	opts = {
		mappings = {
			add = "ys",
			delete = "ds",
			replace = "cs",
		},
	},

	event = { "VeryLazy" },
}
