-- Agent prompt editor
-- https://github.com/ruicsh/briefing.nvim

local T = require("lib")

return {
	"ruicsh/briefing.nvim",
	keys = {
		{ "<c-y>", "<cmd>Briefing<cr>", mode = { "n", "v" }, desc = "Briefing: Toggle" },
	},
	opts = {
		debug = false,
		keymaps = {
			close = { "<c-d>", "close", mode = "ni", desc = "Briefing: Close" },
		},
		window = {
			title = "",
		},
		adapter = {
			name = "sidekick",
			sidekick = {
				tool = T.env.get("AI_CODING_AGENT_TOOL"),
			},
		},
	},
}
