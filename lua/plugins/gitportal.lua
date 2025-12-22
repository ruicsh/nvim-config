-- Open files in git hosting portals.
-- https://codeberg.org/trevorhauter/gitportal.nvim

return {
	"https://codeberg.org/trevorhauter/gitportal.nvim",
	keys = function()
		local gitportal = require("gitportal")

		local mappings = {
			{ "<leader>hx", gitportal.open_file_in_browser, "Open in browser", { mode = { "n", "x" } } },
			{ "<leader>hX", gitportal.open_file_in_neovim, "Open in neovim" },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Git")
	end,
	opts = {
		switch_branch_or_commit_upon_ingestion = "ask_first",
	},
}
