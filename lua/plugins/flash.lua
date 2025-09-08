-- Jump around with search labels
-- https://github.com/folke/flash.nvim

return {
	"folke/flash.nvim",
	keys = function()
		local flash = require("flash")

		local mappings = {
			{ "<c-f>", flash.jump, "Jump", { mode = { "n", "o", "x" } } },
			{ "<leader>v", flash.treesitter, "Treesitter Jump", { mode = { "n", "o", "x" } } },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Flash")
	end,
	opts = {
		labels = "asdfqwerzxcv", -- Limit labels to left side of the keyboard
		search = {
			wrap = true,
		},
		highlight = {
			backdrop = false,
		},
		modes = {
			char = {
				enabled = true,
				highlight = { backdrop = false },
				multi_line = true,
			},
			treesitter = {
				label = {
					after = false,
					style = "overlay",
				},
			},
		},
		prompt = {
			win_config = { border = "none" },
		},
	},
}
