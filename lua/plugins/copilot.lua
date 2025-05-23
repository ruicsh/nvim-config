-- GitHub Copilot suggestions
-- https://github.com/zbirenbaum/copilot.lua

return {
	"zbirenbaum/copilot.lua",
	opts = {
		copilot_model = "gpt-4o-copilot",
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
		panel = {
			enabled = false,
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = "<c-]>",
				accept_word = nil,
				accept_line = "<c-j>",
				next = nil,
				prev = nil,
				dismiss = "<c-e>",
			},
		},
	},

	cmd = "Copilot",
	event = "InsertEnter",
	enabled = not vim.g.vscode,
}
