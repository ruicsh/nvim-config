--  CSS colors
-- https://github.com/norcalli/nvim-colorizer.lua

return {
	"norcalli/nvim-colorizer.lua",
	config = function()
		local colorizer = require("colorizer")
		colorizer.setup({
			"css",
			"scss",
			"lua",
			"javascript",
			"typescript",
			"typescriptreact",
			"javascriptreact",
		}, {
			RGB = true,
			RRGGBB = true,
			names = true,
			RRGGBBAA = true,
			rgb_fn = true,
			hsl_fn = true,
			css = true,
			css_fn = true,
			mode = "background",
		})
	end,

	event = { "VeryLazy" },
}
