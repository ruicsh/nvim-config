-- Better % matching for vim, with language awareness.
-- https://github.com/andymass/vim-matchup

return {
	"andymass/vim-matchup",
	config = function()
		vim.g.matchup_mappings_enabled = 0 -- Disable default mappings
		vim.g.matchup_matchparen_deferred = 1 -- Delay to highlight matchparen
		vim.g.matchup_matchparen_pumvisible = 0 -- Don't highlight when pumvisible
		vim.g.matchup_matchparen_offscreen = {} -- Don't display offscreen on statusline

		require("match-up").setup({})

		local k = vim.keymap.set

		-- Use `m` instead of `%`
		k("n", "mm", "m'<plug>(matchup-%)", { desc = "Next match word" }) -- Don't override the mark key in normal mode
		k({ "o", "x" }, "m", "<plug>(matchup-%)", { desc = "Next match word" })
		k({ "n", "o", "x" }, "gm", "<plug>(matchup-g%)", { desc = "Previous match word" })
		k({ "n", "o", "x" }, "[m", "<plug>(matchup-[%)", { desc = "Previous outer open word" })
		k({ "n", "o", "x" }, "]m", "<plug>(matchup-]%)", { desc = "Next outer close word" })
		k({ "n", "o", "x" }, "zm", "<plug>(matchup-z%)", { desc = "Jump inside next block" })
		k({ "o", "x" }, "am", "<plug>(matchup-a%)", { desc = "Around an any-block" })
		k({ "o", "x" }, "im", "<plug>(matchup-i%)", { desc = "Inside an any-block" })
	end,
}
