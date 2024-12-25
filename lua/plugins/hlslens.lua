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
		local kopts = { silent = true, unique = true }

		k("n", "n", [[:execute('normal! ' . v:count1 . 'n')<cr>:lua require('hlslens').start()<cr>]], kopts)
		k("n", "N", [[:execute('normal! ' . v:count1 . 'N')<cr>:lua require('hlslens').start()<cr>]], kopts)
		k("n", "*", [[*:lua require('hlslens').start()<cr>]], kopts)
		k("n", "#", [[#:lua require('hlslens').start()<cr>]], kopts)
		k("n", "g*", [[g*:lua require('hlslens').start()<cr>]], kopts)
		k("n", "g#", [[g#:lua require('hlslens').start()<cr>]], kopts)
	end,

	event = { "VeryLazy" },
}
