-- Jump around with search labels
-- https://github.com/folke/flash.nvim

return {
	"folke/flash.nvim",
	keys = function()
		local flash = require("flash")

		local mappings = {
			{ "s", flash.jump, "Jump" },
			{ "r", flash.remote, "Remote", { mode = "o" } },
			{ "<leader><s-v>", flash.treesitter, "Treesitter" },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Flash")
	end,
	opts = {
		highlight = {
			backdrop = false,
			matches = false,
		},
		labels = "asdfqwerzxcv", -- Limit labels to left side of the keyboard
		modes = {
			char = {
				char_actions = function(motion)
					return {
						[motion:lower()] = "next",
						[motion:upper()] = "prev",
					}
				end,
				highlight = {
					backdrop = false,
				},
				jump_labels = false,
				keys = { "f", "F", "t", "T" },
				multi_line = false,
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
			enabled = false,
		},
		search = {
			wrap = true,
		},
	},

	event = "VeryLazy",
}
