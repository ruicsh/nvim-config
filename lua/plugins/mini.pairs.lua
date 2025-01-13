-- Autopairs.
-- https://github.com/echasnovski/mini.pairs

return {
	"echasnovski/mini.pairs",
	opts = {
		mappings = {
			-- Don't close pairs if there's a character on the right
			["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][%W]" },
			["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][%W]" },
			["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][%W]" },

			[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\][%W]" },
			["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\][%W]" },
			["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\][%W]" },

			['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\][%W]", register = { cr = false } },
			["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\][%W]", register = { cr = false } },
			["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\][%W]", register = { cr = false } },
		},
	},

	event = { "InsertEnter" },
}
