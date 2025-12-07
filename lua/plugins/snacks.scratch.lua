-- Scratchpad.
-- https://github.com/folke/snacks.nvim/blob/main/docs/scratch.md

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")
		local mappings = {
			{ "<leader>e", snacks.scratch.open, "Toggle" },
			{ "<leader>E", snacks.scratch.select, "Select" },
		}
		return vim.fn.get_lazy_keys_config(mappings, "Scratchpad")
	end)(),
	opts = {
		styles = {
			scratch = {
				border = { "", "", "", "", "", "", "", "│" },
				col = math.floor(vim.o.columns * 0.5),
				height = vim.o.lines - vim.o.cmdheight - 1,
				row = 0,
				width = math.floor(vim.o.columns * 0.5),
			},
		},
		scratch = {
			enabled = true,
		},
	},
}
