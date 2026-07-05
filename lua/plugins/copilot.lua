-- GitHub Copilot suggestions
-- https://github.com/zbirenbaum/copilot.lua

local T = require("lib")

return {
	"zbirenbaum/copilot.lua",
	cond = T.env.get("AI_SUGGESTIONS_ENGINE") == "copilot",
	event = "InsertEnter",
	opts = {
		filetypes = {
			["."] = false,
			css = false,
			csv = false,
			gitcommit = false,
			gitrebase = false,
			help = false,
			hgcommit = false,
			markdown = false,
			scss = false,
			svn = false,
			yaml = false,
			[""] = false,
		},
		panel = {
			enabled = false,
		},
		suggestion = {
			enabled = T.env.get_bool("AI_SUGGESTIONS_ENABLED"),
			auto_trigger = true,
			keymap = {
				accept = "<c-]>",
				accept_word = "<a-w>",
				accept_line = "<a-e>",
				next = "<a-n>",
				prev = "<a-p>",
				dismiss = "<c-d>",
			},
		},
	},
	config = function(_, opts)
		local copilot = require("copilot")

		vim.g.copilot_proxy = T.env.get("COPILOT_PROXY")

		copilot.setup(opts)
	end,
}
