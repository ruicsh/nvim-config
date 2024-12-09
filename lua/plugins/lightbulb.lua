-- Show that a textDocument/codeAction is available
-- https://github.com/kosayoda/nvim-lightbulb

return {
	"kosayoda/nvim-lightbulb",
	opts = {
		autocmd = {
			enabled = true,
		},
		validate_config = "never",
		code_lenses = true,
		sign = {
			enabled = true,
			text = "",
			lens_text = "",
			hl = "LightBulbSign",
		},
	},

	event = { "VeryLazy" },
}
