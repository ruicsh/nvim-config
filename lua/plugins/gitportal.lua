-- Open files in git hosting portals.
-- https://codeberg.org/trevorhauter/gitportal.nvim

return {
	"https://codeberg.org/trevorhauter/gitportal.nvim",
	keys = {
		{ "<leader>hx", "<cmd>GitPortal browse_file<cr>", desc = "Git: Open in browser", mode = { "n", "x" } },
		{ "<leader>hX", "<cmd>GitPortal open_link<cr>", desc = "Git: Open in neovim" },
	},
	opts = {
		switch_branch_or_commit_upon_ingestion = "ask_first",
	},
}
