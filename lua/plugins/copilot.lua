-- GitHub Copilot suggestions
-- https://github.com/zbirenbaum/copilot.lua

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
				accept = "<c-y>",
				accept_word = "<c-w>",
				accept_line = "<c-,>",
				next = "<c-j>",
				prev = "<c-k>",
				dismiss = "<c-]>",
			},
		},
		filetypes = {
			yaml = false,
			markdown = false,
			help = false,
			gitcommit = false,
			gitrebase = false,
			hgcommit = false,
			svn = false,
			cvs = false,
			["."] = false,
		},
	},

	cmd = "Copilot",
	event = { "InsertEnter" },
}
