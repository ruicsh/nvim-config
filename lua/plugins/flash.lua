-- Jump around with search labels
-- https://github.com/folke/flash.nvim

return {
	"folke/flash.nvim",
	keys = function()
		local flash = require("flash")

		local mappings = {
			{ "s", flash.jump, "Jump", { mode = { "n", "o", "x" } } },
			{ "<leader>v", flash.treesitter, "Treesitter Jump", { mode = { "n", "o", "x" } } },
			{ "<c-s>", flash.toggle, "Toggle Flash", { mode = { "c" } } },
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
				multi_line = false,
			},
			treesitter = {
				label = {
					after = false,
					style = "overlay",
				},
			},
		},
		prompt = {
			enabled = false,
		},
	},
}
