-- Readline motions (insert and command mode).
-- https://github.com/assistcontrol/readline.nvim

return {
	"assistcontrol/readline.nvim",
	keys = function()
		local readline = require("readline")

		local mappings = {
			{ "<a-b>", readline.backward_word, "Jump word (backward)", { mode = { "i", "c" } } },
			{ "<a-f>", readline.forward_word, "Jump word (forward)", { mode = { "i", "c" } } },
			{ "<c-a>", readline.beginning_of_line, "Beginning of line", { mode = { "i", "c" } } },
			{ "<c-b>", "<left>", "Jump character (backward)", { mode = { "i", "c" } } },
			{ "<c-d>", readline.kill_word, "Delete word (forward)", { mode = { "i", "c" } } },
			{ "<c-e>", readline.end_of_line, "End of line", { mode = { "i", "c" } } },
			{ "<c-f>", "<right>", "Jump character (forward)", { mode = { "i", "c" } } },
			{ "<c-k>", readline.kill_line, "Delete line (forward)", { mode = { "i", "c" } } },
			{ "<c-u>", readline.backward_kill_line, "Delete line (backward)", { mode = { "i", "c" } } },
			{ "<c-w>", readline.unix_word_rubout, "Delete word (backward)", { mode = { "i", "c" } } },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Readline")
	end,
	config = function() end,
}
