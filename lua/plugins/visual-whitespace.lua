-- Render whitespace characters only in visual mode
-- https://github.com/mcauley-penney/visual-whitespace.nvim

return {
	"mcauley-penney/visual-whitespace.nvim",

	-- Lazy load on entering visual mode
	event = "ModeChanged *:[vV\22]",
}
