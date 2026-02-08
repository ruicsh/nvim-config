-- GitHub Copilot suggestions
-- https://github.com/zbirenbaum/copilot.lua

local T = require("lib")

return {
	"zbirenbaum/copilot.lua",
	opts = {
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
			[""] = false,
		},
		panel = {
			enabled = false,
		},
		suggestion = {
			enabled = not T.env.get_bool("COPILOT_DISABLE_SUGGESTIONS"),
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

		vim.g.copilot_proxy = T.env.get("COPILOT_PROXY")

		copilot.setup(opts)
	end,

	cmd = "Copilot",
	event = "InsertEnter",
}
