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
				accept_word = "<a-]>",
				accept_line = "<a-[>",
				next = "<a-n>",
				prev = "<a-p>",
				dismiss = "<a-e>",
			},
		},
	},
	config = function(_, opts)
		local copilot = require("copilot")

		vim.g.copilot_proxy = vim.fn.env_get("COPILOT_PROXY")

		copilot.setup(opts)
	end,

	commit = "4958fb9390f624cb389be2772e3c5e718e94d8b6",
	cmd = "Copilot",
	event = "InsertEnter",
}
