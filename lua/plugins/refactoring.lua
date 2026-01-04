-- Code refactoring.
-- https://github.com/ThePrimeagen/refactoring.nvim

return {
	"ThePrimeagen/refactoring.nvim",
	keys = function()
		local rf = require("refactoring")

		local function cmd(op)
			return function()
				return rf.refactor(op)
			end
		end

		local mappings = {
			{ "<leader>ff", "Extract Function", "x" },
			{ "<leader>fF", "Inline Function", "n" },
			{ "<leader>fv", "Extract Variable", "x" },
			{ "<leader>fV", "Inline Variable", "n" },
		}

		return vim.tbl_map(function(mapping)
			local key, operation, mode = mapping[1], mapping[2], mapping[3]
			return {
				key,
				cmd(operation),
				desc = "Refactoring: " .. operation,
				mode = mode or { "n", "x" },
				expr = true,
			}
		end, mappings)
	end,

	event = "BufReadPost",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
}
