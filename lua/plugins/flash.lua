-- Jump around with search labels
-- https://github.com/folke/flash.nvim

return {
	"folke/flash.nvim",
	keys = function()
		local flash = require("flash")

		local mappings = {
			{ "<c-f>", flash.jump, "Jump", { mode = { "n", "o", "x" } } },
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
			char = {
				enabled = false,
			},
		},
	},
}
