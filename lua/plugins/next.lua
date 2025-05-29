-- Repeatable movements
-- https://github.com/ghostbuster91/nvim-next

return {
	"ghostbuster91/nvim-next",
	config = function()
		local next = require("nvim-next")
		local nvim_next_builtins = require("nvim-next.builtins")
		next.setup({
			default_mappings = {
				repeat_style = "original",
			},
			items = {
				nvim_next_builtins.f,
				nvim_next_builtins.t,
			},
		})
	end,
}
