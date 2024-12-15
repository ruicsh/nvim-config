-- Log statements
-- https://github.com/andrewferrier/debugprint.nvim

return {
	"andrewferrier/debugprint.nvim",
	opts = {
		print_tag = "ruic",
		keymaps = {
			normal = {
				plain_below = "glp",
				plain_above = "glP",
				variable_below = "glv",
				variable_above = "glV",
				variable_below_alwaysprompt = nil,
				variable_above_alwaysprompt = nil,
				textobj_below = "glo",
				textobj_above = "glO",
				toggle_comment_debug_prints = nil,
				delete_debug_prints = nil,
			},
			visual = {
				variable_below = "glv",
				variable_above = "glV",
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
