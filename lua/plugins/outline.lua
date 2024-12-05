-- LSP symbols
-- https://github.com/hedyhli/outline.nvim

return {
	"hedyhli/outline.nvim",
	opts = {
		outline_window = {
			auto_jump = true,
			show_relative_numbers = true,
		},
		symbols = {
			icon_source = "lspkind",
		},
	},

	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	requirements = {
		{ "onsails/lspkind.nvim" },
	},
}
