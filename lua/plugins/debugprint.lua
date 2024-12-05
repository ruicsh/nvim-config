-- Log statements
-- https://github.com/andrewferrier/debugprint.nvim

return {
	"andrewferrier/debugprint.nvim",
	opts = {
		print_tag = "ruic",
		keymaps = {
			normal = {
				plain_below = "g?p",
				plain_above = "g?P",
				variable_below = "g?v",
				variable_above = "g?V",
				variable_below_alwaysprompt = nil,
				variable_above_alwaysprompt = nil,
				textobj_below = "g?o",
				textobj_above = "g?O",
				toggle_comment_debug_prints = nil,
				delete_debug_prints = nil,
			},
			visual = {
				variable_below = "g?v",
				variable_above = "g?V",
			},
		},
		commands = {
			toggle_comment_debug_prints = "ToggleCommentDebugPrints",
			delete_debug_prints = "DeleteDebugPrints",
		},
		filetypes = {
			["javascript"] = { display_location = false },
			["javascriptreact"] = { display_location = false },
			["typescript"] = { display_location = false },
			["typescriptreact"] = { display_location = false },
		},
	},

	main = "debugprint",
	event = { "VeryLazy" },
}
