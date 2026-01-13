-- Readline motions (insert and command mode).
-- https://github.com/assistcontrol/readline.nvim

return {
	"assistcontrol/readline.nvim",
	keys = function()
		local r = require("readline")

		return {
			{ "<c-b>", "<left>", desc = "Jump character (backward)", mode = { "i", "c" } },
			{ "<c-f>", "<right>", desc = "Jump character (forward)", mode = { "i", "c" } },
			{ "<a-b>", r.backward_word, desc = "Jump word (backward)", mode = { "i", "c" } },
			{ "<a-f>", r.forward_word, desc = "Jump word (forward)", mode = { "i", "c" } },

			{ "<c-a>", r.beginning_of_line, desc = "Beginning of line", mode = { "i", "c" } },
			{ "<c-e>", r.end_of_line, desc = "End of line", mode = { "i", "c" } },
			{ "<c-u>", r.backward_kill_line, desc = "Delete line (backward)", mode = { "i", "c" } },
			{ "<c-k>", r.kill_line, desc = "Delete line (forward)", mode = { "i", "c" } },

			{ "<c-h>", "<bs>", desc = "Delete char (backward)", mode = { "i", "c" } },
			{ "<c-d>", "<del>", desc = "Delete char (forward)", mode = { "i", "c" } },
			{ "<a-d>", r.kill_word, desc = "Delete word (forward)", mode = { "i", "c" } },
			{ "<a-bs>", r.backward_kill_word, desc = "Delete word (backward)", mode = { "i", "c" } },
			{ "<c-w>", r.unix_word_rubout, desc = "Delete WORD (backward)", mode = { "i", "c" } },
		}
	end,
	config = function() end,
}
