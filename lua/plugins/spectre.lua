-- Search/replace
-- https://github.com/nvim-pack/nvim-spectre

return {
	"nvim-pack/nvim-spectre",
	keys = {
		{ "<leader>r", ":Spectre %<cr>", { desc = "[r]eplace" } },
	},
	opts = {
		highlight = {
			search = "SpectreSearchHl",
			replace = "SpectreReplaceHl",
		},
	},

	cmd = { "Spectre" },
}
