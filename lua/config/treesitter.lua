local M = {}

M = {
	query = {
		--Used to define textobjects and motions
		scope = {
			"@conditional",
			"@loop",
			"@block",
			"@function",
			"@class",
			"@scopename",
		},
	},
}

return M
