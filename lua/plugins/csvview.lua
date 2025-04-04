-- CSV file editing
-- https://github.com/hat0uma/csvview.nvim

local augroup = vim.api.nvim_create_augroup("ruicsh/plugins/csvview", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "csv",
	callback = function()
		require("csvview").enable()
	end,
})

return {
	"hat0uma/csvview.nvim",
	opts = {
		view = {
			display_mode = "border",
		},
	},

	ft = { "csv" },
}
