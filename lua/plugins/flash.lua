-- Jump around with search labels
-- https://github.com/folke/flash.nvim

return {
	"folke/flash.nvim",
	opts = {
		highlight = {
			backdrop = false,
		},
		jump = {
			autojump = true,
			nohlsearch = true,
		},
		labels = "asdfqwerzxcv", -- Limit labels to left side of the keyboard
		modes = {
			char = {
				char_actions = function()
					return {
						[";"] = "next",
						["F"] = "left",
						["f"] = "right",
					}
				end,
				enabled = true,
				keys = { "f", "F", "t", "T", ";" },
				highlight = {
					backdrop = false,
				},
				jump_labels = false,
				multi_line = true,
			},
			search = {
				enabled = true,
				highlight = {
					backdrop = false,
				},
				jump = {
					autojump = false,
				},
			},
		},
		prompt = {
			win_config = { border = "none" },
		},
		search = {
			wrap = true,
		},
	},
}
