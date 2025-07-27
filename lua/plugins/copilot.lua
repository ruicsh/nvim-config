-- GitHub Copilot suggestions
-- https://github.com/zbirenbaum/copilot.lua

return {
	"zbirenbaum/copilot.lua",
	opts = {
		copilot_model = "gpt-4o-copilot",
		filetypes = {
			["."] = false,
			css = false,
			cvs = false,
			gitcommit = false,
			gitrebase = false,
			help = false,
			hgcommit = false,
			markdown = false,
			scss = false,
			svn = false,
			yaml = false,
		},
		panel = {
			enabled = false,
		},
		suggestion = {
			enabled = vim.fn.env_get("COPILOT_DISABLE_SUGGESTIONS") ~= "true",
			auto_trigger = true,
			keymap = {
				accept = "<c-]>",
				accept_word = "<a-l>",
				accept_line = "<a-j>",
				next = "<a-n>",
				prev = "<a-p>",
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
}
