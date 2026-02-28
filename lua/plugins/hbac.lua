-- Buffer auto-closer.
-- https://github.com/axkirillov/hbac.nvim

return {
	"axkirillov/hbac.nvim",
	opts = {
		autoclose = true,
		threshold = 10,
		close_command = function(bufnr)
			require("snacks").bufdelete.delete(bufnr)
		end,
		close_buffers_with_windows = false,
	},

	event = "BufRead",
}
