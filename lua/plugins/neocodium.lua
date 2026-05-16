-- Neocodium AI suggestions
-- https://github.com/monkoose/neocodeium

local T = require("lib")

return {
	"monkoose/neocodeium",
	enabled = T.env.get("AI_SUGGESTIONS_ENGINE") == "codeium",
	keys = function()
		local nc = require("neocodeium")

		local cycle = function(direction)
			return function()
				nc.cycle(direction)
			end
		end

		return {
			{ "<c-]>", nc.accept, desc = "Neocodium: Accept", mode = "i" },
			{ "<a-w>", nc.accept_word, desc = "Neocodium: Accept word", mode = "i" },
			{ "<a-e>", nc.accept_line, desc = "Neocodium: Accept line", mode = "i" },
			{ "<a-n>", cycle(1), desc = "Neocodium: Next suggestion", mode = "i" },
			{ "<a-p>", cycle(-1), desc = "Neocodium: Previous suggestion", mode = "i" },
			{ "<c-d>", nc.clear, desc = "Neocodium: Dismiss suggestion", mode = "i" },
		}
	end,
	opts = {
		enabled = T.env.get_bool("AI_SUGGESTIONS_ENABLED"),
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
		silent = true,
		show_label = false,
	},
}
