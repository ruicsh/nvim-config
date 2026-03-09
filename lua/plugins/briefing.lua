-- Agent prompt editor
-- https://github.com/ruicsh/briefing.nvim

return {
	"ruicsh/briefing.nvim",
	keys = {
		{ "<leader>ab", "<cmd>Briefing<cr>", mode = { "n", "v" }, desc = "Briefing: Toggle" },
	},
	opts = {
		debug = false,
		keymaps = {
			close = { "<c-d>", "close", mode = "ni", desc = "Briefing: Close" },
		},
		window = {
			wo = {
				relativenumber = true,
			},
		},
		adapter = {
			name = "sidekick",
			sidekick = {
				tool = "opencode",
			},
		},
	},
}
