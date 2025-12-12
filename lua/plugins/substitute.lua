-- Replace and exchange actions.
-- https://github.com/gbprod/substitute.nvim

return {
	"gbprod/substitute.nvim",
	keys = function()
		local s = require("substitute")
		local x = require("substitute.exchange")

		local mappings = {
			-- Substitute
			{ "<leader>r", s.operator, "Operator" },
			{ "<leader>rr", s.line, "Line" },
			{ "<leader>R", s.eol, "End of line" },
			{ "<leader>r", s.visual, "Selection", { mode = "x" } },
			-- Exchange
			{ "<leader>x", x.operator, "Operator" },
			{ "<leader>xx", x.line, "Line" },
			{ "<leader>x", x.visual, "Selection", { mode = "x" } },
			{ "<leader>xc", x.cancel, "Cancel" },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Substitute")
	end,
	opts = {
		exchange = {},
		highlight_substituted_text = {
			timer = 200,
		},
	},
}
