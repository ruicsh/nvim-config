-- Autopairs.
-- https://github.com/echasnovski/mini.pairs

return {
	"echasnovski/mini.pairs",
	opts = {
		mappings = {
			-- https://gist.github.com/tmerse/dc21ec932860013e56882f23ee9ad8d2

			-- Only opens pairs when followed by spaces or closing brackets
			["("] = { action = "open", pair = "()", neigh_pattern = ".[%s%z%)}%]]" },
			["["] = { action = "open", pair = "[]", neigh_pattern = ".[%s%z%)}%]]" },
			["{"] = { action = "open", pair = "{}", neigh_pattern = ".[%s%z%)}%]]" },

			[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
			["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
			["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

			-- Prevent pairing if either side is a letter
			['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
			["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
			["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
		},
	},

	event = { "InsertEnter" },
}
