-- Jump around with search labels
-- https://github.com/folke/flash.nvim

return {
	"folke/flash.nvim",
	keys = function()
		local flash = require("flash")

		local mappings = {
			{ "s", flash.jump, "Jump", { mode = { "n", "o", "v" } } },
			{ "<leader>v", flash.treesitter, "Treesitter", { mode = { "n", "x", "o" } } },
			{ "<c-v>", flash.treesitter_search, "Treesitter Search", { mode = "n" } },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Flash")
	end,
	opts = {
		search = {
			wrap = true,
		},
		highlight = {
			backdrop = false,
		},
		modes = {
			search = {
				enabled = true,
			},
			char = {
				enabled = true,
				autohide = true,
				highlight = {
					backdrop = false,
				},
			},
			treesitter = {
				jump = {
					autojump = false,
					pos = "range",
				},
				label = {
					before = true,
					after = false,
					style = "overlay",
				},
			},
			treesitter_search = {
				enabled = true,
				label = {
					before = true,
					after = false,
					style = "overlay",
				},
			},
		},
	},

	event = { "BufReadPre", "BufNewFile" },
}
