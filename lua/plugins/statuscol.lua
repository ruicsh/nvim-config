-- Status column.
-- https://github.com/luukvbaal/statuscol.nvim

return {
	"luukvbaal/statuscol.nvim",
	config = function()
		local statuscol = require("statuscol")
		local builtin = require("statuscol.builtin")

		statuscol.setup({
			segments = {
				{ text = { "%s" }, click = "v:lua.ScSa" },
				{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
				{
					text = { builtin.lnumfunc, " " },
					condition = { true, builtin.not_empty },
					click = "v:lua.ScLa",
				},
			},
		})
	end,

	event = { "VeryLazy" },
}
