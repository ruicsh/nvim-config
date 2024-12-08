-- Search results labels
-- https://github.com/kevinhwang91/nvim-hlslens

return {
	"kevinhwang91/nvim-hlslens",
	opts = {
		calm_down = true,
		nearest_only = true,
	},
	config = function(_, opts)
		local hlslens = require("hlslens")
		hlslens.setup(opts)

		local k = vim.api.nvim_set_keymap
		local kopts = { silent = true }

		k("n", "n", [[<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>]], kopts)
		k("n", "N", [[<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>]], kopts)
		k("n", "*", [[*<cmd>lua require('hlslens').start()<cr>]], kopts)
		k("n", "#", [[#<cmd>lua require('hlslens').start()<cr>]], kopts)
		k("n", "g*", [[g*<cmd>lua require('hlslens').start()<cr>]], kopts)
		k("n", "g#", [[g#<cmd>lua require('hlslens').start()<cr>]], kopts)
	end,

	event = { "VeryLazy" },
}
