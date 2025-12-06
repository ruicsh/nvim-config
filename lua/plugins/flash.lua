-- Jump around with search labels
-- https://github.com/folke/flash.nvim

return {
	"folke/flash.nvim",
	keys = function()
		local flash = require("flash")

		local mappings = {
			{ "s", flash.jump, "Jump", mode = { "n", "x", "o" } },
			{ "<leader><s-v>", flash.treesitter, "Treesitter", mode = { "n", "x", "o" } },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Flash")
	end,
	opts = {
		highlight = {
			backdrop = false,
		},
		labels = "asdfqwerzxcv", -- Limit labels to left side of the keyboard
		modes = {
			char = {
				char_actions = function()
					return {
						["F"] = "left",
						["f"] = "right",
						["T"] = "left",
						["t"] = "right",
					}
				end,
				highlight = {
					backdrop = false,
				},
				jump_labels = false,
				multi_line = false,
				keys = { "f", "F", "t", "T" },
			},
			treesitter = {
				actions = {
					["<c-a>"] = "next", -- Increment selection
					["<c-x>"] = "prev", -- Decrement selection
				},
				labels = "", -- Disable labels for treesitter mode
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
