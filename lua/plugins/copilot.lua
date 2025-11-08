-- GitHub Copilot suggestions
-- https://github.com/zbirenbaum/copilot.lua

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

	cmd = "Copilot",
	event = "InsertEnter",
}
