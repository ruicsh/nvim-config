-- Frecency-ranked, typo-resistant file search backend.
-- https://github.com/dmtrKovalenko/fff.nvim
--
-- The picker UI comes from Snacks; see `lua/lib/fff.lua` for the sources.
--
-- fff indexes the directory Neovim started in and respects .gitignore/.ignore.
-- Changing cwd later does not re-index: restart or call
-- `require("fff").change_indexing_directory(path)`.

return {
	"dmtrKovalenko/fff",
	-- Downloads a prebuilt binary or falls back to `cargo build`
	build = function()
		require("fff.download").download_or_build_binary()
	end,
	lazy = false, -- The plugin lazy-initialises itself
}
