-- GitHub Copilot suggestions
-- https://github.com/zbirenbaum/copilot.lua

return {
	"zbirenbaum/copilot.lua",
	keys = function()
		local function cancel_cmp()
			require("cmp").mapping.abort()
			require("copilot").suggestion.accept()
		end

		local mappings = {
			{ "<c-s-e>", cancel_cmp, "Accept suggestion" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "AI")
	end,
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
