-- Terminal
-- https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")
		local terminal = snacks.terminal

		local function open_terminal()
			terminal.open("nu")
		end

		return {
			{ "<c-t>", open_terminal, desc = "Terminal: Open" },
		}
	end)(),
	opts = {
		terminal = {
			win = {
				border = "rounded",
				width = 0.6,
				height = 0.6,
			},
		},
	},
}
