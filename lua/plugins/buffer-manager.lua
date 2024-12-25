-- Buffer picker
-- https://github.com/j-morano/buffer_manager.nvim

return {
	"j-morano/buffer_manager.nvim",
	config = function()
		local bm = require("buffer_manager")
		bm.setup({
			show_indicators = true,
			format_function = function(buf)
				-- display the parent directory name and basename
				local path = vim.fs.dirname(buf)
				local parent = vim.fs.basename(path)
				local basename = vim.fs.basename(buf)
				if parent == "." then
					return basename
				end
				return vim.fs.joinpath(parent, basename)
			end,
			width = 0.5,
		})

		local bmui = require("buffer_manager.ui")
		local k = vim.keymap.set
		local opts = { noremap = true, silent = true, unique = true }

		k("n", "§", bmui.toggle_quick_menu, opts)
	end,

	event = { "VeryLazy" },
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
