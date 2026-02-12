-- Replace and exchange actions.
-- https://github.com/gbprod/substitute.nvim

return {
	"gbprod/substitute.nvim",
	keys = function()
		local s = require("substitute")
		local x = require("substitute.exchange")

		return {
			-- Substitute
			{ "<leader>r", s.operator, desc = "Substitute: Operator" },
			{ "<leader>rr", s.line, desc = "Substitute: Line" },
			{ "<leader>R", s.eol, desc = "Substitute: End of line" },
			{ "<leader>r", s.visual, desc = "Substitute: Selection", mode = "x" },
			-- Exchange
			{ "<leader>x", x.operator, desc = "Substitute: Operator" },
			{ "<leader>xx", x.line, desc = "Substitute: Line" },
			{ "<leader>x", x.visual, desc = "Substitute: Selection", mode = "x" },
			{ "<leader>xc", x.cancel, desc = "Substitute: Cancel" },
		}
	end,
	opts = {
		exchange = {},
		highlight_substituted_text = {
			timer = 200,
		},
	},
}
