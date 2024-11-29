-- Command line
-- https://github.com/gelguy/wilder.nvim

return {
	"gelguy/wilder.nvim",
	keys = {
		":",
		"/",
		"?",
	},
	config = function()
		local wilder = require("wilder")

		wilder.setup({
			modes = { ":", "/", "?" },
		})

		wilder.set_option(
			"renderer",
			wilder.popupmenu_renderer(wilder.popupmenu_palette_theme({
				border = "rounded",
				highlighter = wilder.basic_highlighter(),
				max_height = "50%",
				min_height = 0,
				prompt_position = "bottom",
				reverse = 1,
			}))
		)
	end,
}
