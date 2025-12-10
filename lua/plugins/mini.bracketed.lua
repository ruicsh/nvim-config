-- Go forward/backward with square brackets.
-- https://github.com/nvim-mini/mini.bracketed

return {
	"nvim-mini/mini.bracketed",
	keys = function()
		local mb = require("mini.bracketed")

		local function goto_diag_error(direction)
			return function()
				local opts = { severity = vim.diagnostic.severity.ERROR }
				mb.diagnostic(direction, opts)
			end
		end

		local mappings = {
			{ "[E", goto_diag_error("first"), "LSP: First diagnostic error" },
			{ "[e", goto_diag_error("backward"), "LSP: Previous diagnostic error" },
			{ "]e", goto_diag_error("forward"), "LSP: Next diagnostic error" },
			{ "]E", goto_diag_error("last"), "LSP: Last diagnostic error" },
		}

		return vim.fn.get_lazy_keys_config(mappings, "")
	end,
	opts = {
		buffer = { suffix = "b", options = {} },
		comment = { suffix = "", options = {} },
		conflict = { suffix = "x", options = {} },
		diagnostic = { suffix = "d", options = {} },
		file = { suffix = "", options = {} },
		indent = { suffix = "", options = {} },
		jump = { suffix = "", options = {} },
		location = { suffix = "l", options = {} },
		oldfile = { suffix = "o", options = {} },
		quickfix = { suffix = "q", options = {} },
		treesitter = { suffix = "t", options = {} },
		undo = { suffix = "u", options = {} },
		window = { suffix = "", options = {} },
		yank = { suffix = "y", options = {} },
	},
}
