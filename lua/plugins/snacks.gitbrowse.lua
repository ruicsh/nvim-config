-- Open the repo of the active file in the browser.
-- https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local mappings = {
			{ "<leader>hx", snacks.gitbrowse.open, "Git: Open in browser" },
		}

		return vim.fn.get_lazy_keys_conf(mappings)
	end)(),
	opts = {
		gitbrowse = {
			enabled = true,
		},
	},
}
