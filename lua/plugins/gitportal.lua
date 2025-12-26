-- Open files in git hosting portals.
-- https://codeberg.org/trevorhauter/gitportal.nvim

return {
	"https://codeberg.org/trevorhauter/gitportal.nvim",
	keys = function()
		local gp = require("gitportal")

		return {
			{ "<leader>hx", gp.open_file_in_browser, desc = "Git: Open in browser", mode = { "n", "x" } },
			{ "<leader>hX", gp.open_file_in_neovim, desc = "Git: Open in neovim" },
		}
	end,
	opts = {
		switch_branch_or_commit_upon_ingestion = "ask_first",
	},
}
