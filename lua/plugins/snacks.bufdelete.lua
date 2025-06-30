-- Delete buffers without disrupting window layout.
-- https://github.com/folke/snacks.nvim/blob/main/docs/bufdelete.md

return {
	"folke/snacks.nvim",

	keys = (function()
		local snacks = require("snacks")

		local function close_buffer_or_window_or_quit()
			-- If the current buffer is empty, close window or quit Vim
			if vim.fn.expand("%:p") == "" then
				-- If last window is empty, quit Vim
				if #vim.api.nvim_list_wins() == 1 then
					vim.cmd("q")
				else
					-- If there are other windows, close the current window
					vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
				end
			else
				snacks.bufdelete.delete()
			end
		end

		local mappings = {
			{ "<c-q>", close_buffer_or_window_or_quit, "Delete buffer" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Buffers")
	end)(),
	opts = {
		bufdelete = {
			enabled = true,
		},
	},

	event = "VeryLazy",
	enabled = not vim.g.vscode,
}
