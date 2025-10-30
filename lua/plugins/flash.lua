-- Jump around with search labels
-- https://github.com/folke/flash.nvim

return {
	"folke/flash.nvim",
	opts = {
		labels = "asdfqwerzxcv", -- Limit labels to left side of the keyboard
		modes = {
			char = {
				char_actions = function()
					return {
						[";"] = "next",
						["F"] = "left",
						["f"] = "right",
						["T"] = "left",
						["t"] = "right",
					}
				end,
				keys = { "f", "F", "t", "T", ";" },
				highlight = {
					backdrop = false,
				},
				jump_labels = false,
			},
			search = {
				enabled = true,
			},
		},
		prompt = {
			win_config = {
				border = "none",
			},
		},
		search = {
			wrap = true,
		},
	},

	event = "VeryLazy",
}
