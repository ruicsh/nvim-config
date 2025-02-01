-- GitHub Copilot suggestions
-- https://github.com/zbirenbaum/copilot.lua

return {
	"zbirenbaum/copilot.lua",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = "<c-l>",
				accept_word = false,
				accept_line = false,
				next = "<tab>",
				prev = "<s-tab>",
				dismiss = "<c-]>",
			},
		},
		panel = {
			enabled = false,
		},
	},

	event = { "BufRead" },
}
