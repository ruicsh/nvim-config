-- Go forward/backward with square brackets.
-- https://github.com/nvim-mini/mini.bracketed

return {
	"nvim-mini/mini-git",
	keys = function()
		local git = require("mini.git")

		local function show_range_history()
			git.show_range_history({ split = "horizontal" })
		end

		local function show_at_cursor()
			git.show_at_cursor({ split = "horizontal" })
		end

		return {
			{ "<leader>hl", show_range_history, mode = "v", desc = "Git: Show range history" },
			{ "<leader>hK", show_at_cursor, desc = "Git: Show history at cursor" },
		}
	end,
}
