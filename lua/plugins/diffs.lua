-- Git diffs syntax highlighting
-- https://github.com/barrettruth/diffs.nvim

return {
	"barrettruth/diffs.nvim",
	init = function()
		vim.g.diffs = {
			integrations = {
				fugitive = true,
				gitsigns = true,
			},
		}
	end,
}
