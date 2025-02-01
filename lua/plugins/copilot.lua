-- GitHub Copilot suggestions
-- https://github.com/zbirenbaum/copilot.lua.

return {
	"zbirenbaum/copilot.lua",
	opts = {
		panel = {
			enabled = false,
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = "<c-l>",
				accept_word = "<tab>",
				accept_line = false,
				next = "<c-n>",
				prev = "<c-p>",
				dismiss = "<c-e>",
			},
		},
	},

	cmd = "Copilot",
	event = { "InsertEnter" },
}
