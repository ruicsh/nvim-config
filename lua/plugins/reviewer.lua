-- Inline review comments on a diff, send to sidekick
-- https://github.com/ruicsh/reviewer.nvim

local T = require("lib")

return {
	"ruicsh/reviewer.nvim",
	opts = {
		sidekick = {
			tool = T.env.get("AI_CODING_AGENT_TOOL"),
		},
	},

	event = "VeryLazy",
	dependencies = {
		"esmuellert/codediff.nvim",
	},
}
