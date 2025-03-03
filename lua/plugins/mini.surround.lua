-- Surround actions.
-- https://github.com/echasnovski/mini.surround

return {
	"echasnovski/mini.surround",
	opts = {
		mappings = {
			add = "sa",
			delete = "sd",
			find = "",
			find_left = "",
			highlight = "",
			replace = "sr",
			update_n_lines = "",
		},
	},

	event = { "InsertEnter" },
}
