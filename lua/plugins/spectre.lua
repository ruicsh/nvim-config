-- Search/replace
-- https://github.com/nvim-pack/nvim-spectre

return {
	"nvim-pack/nvim-spectre",
	keys = function()
		local mappings = {
			{ "<leader>r", ":Spectre %<cr>", "[r]eplace" },
		}
		return vim.fn.getlazykeysconf(mappings, "Spectre")
	end,
	opts = {
		highlight = {
			search = "SpectreSearchHl",
			replace = "SpectreReplaceHl",
		},
	},

	cmd = { "Spectre" },
}
