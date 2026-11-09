-- Command line tweaks.
-- https://github.com/nvim-mini/mini.cmdline

return {
	"nvim-mini/mini.cmdline",
	opts = {
		-- Blink already provides command line completion. `mini.cmdline`'s
		-- autocomplete works by triggering the built-in `'wildmenu'`, which
		-- would show a second popup next to Blink's. Enable this only after
		-- disabling `cmdline` in `blink.lua`.
		autocomplete = {
			enable = false,
			map_arrows = false,
		},

		-- Fix typos in commands and options as you type.
		autocorrect = {
			enable = true,
		},

		-- Show which lines a command range is about to act on.
		autopeek = {
			enable = true,
			n_context = 1,
		},
	},
}
