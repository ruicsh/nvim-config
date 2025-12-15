-- Zen mode and zoom.
-- https://github.com/folke/snacks.nvim/blob/main/docs/zen.md

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local mappings = {
			{ "<leader>z", snacks.zen.zen, "Toggle" },
			{ "<c-w>z", snacks.zen.zoom, "Zoom" },
		}

		return vim.fn.get_lazy_keys_config(mappings, "ZenMode")
	end)(),
	opts = {
		styles = {
			zen = {
				keys = {
					["q"] = false,
					["<leader>z"] = false,
				},
				zindex = 100,
			},
		},
		zen = {
			toggles = {
				dim = false,
			},
		},
	},
}
