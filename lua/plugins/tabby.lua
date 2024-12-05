-- Tabs
-- https://github.com/nanozuki/tabby.nvim

return {
	"nanozuki/tabby.nvim",
	config = function()
		local theme = {
			fill = "TabLineFill",
			head = "TabLine",
			current_tab = "TabLineSel",
			tab = "TabLine",
			win = "TabLine",
			tail = "TabLine",
		}

		local tabby = require("tabby")
		tabby.setup({
			line = function(line)
				return {
					line.spacer(),
					line.tabs().foreach(function(tab)
						local hl = tab.is_current() and theme.current_tab or theme.tab
						return {
							line.sep("", hl, theme.fill),
							tab.is_current() and "" or "󰆣",
							tab.number(),
							line.sep("", hl, theme.fill),
							hl = hl,
							margin = " ",
						}
					end),
				}
			end,
		})
	end,

	event = { "VimEnter" },
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}
