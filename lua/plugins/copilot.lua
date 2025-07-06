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
				accept_word = "<c-l>",
				accept_line = "<c-s-L>",
				next = nil,
				prev = nil,
				dismiss = "<c-e>",
			},
		},
	},
	config = function(_, opts)
		local copilot = require("copilot")

		vim.g.copilot_proxy = vim.fn.env_get("COPILOT_PROXY")

		copilot.setup(opts)
	end,

	cmd = "Copilot",
	event = "InsertEnter",
	enabled = not vim.g.vscode,
}
