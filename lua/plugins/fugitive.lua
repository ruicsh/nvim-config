-- Git client
-- https://github.com/tpope/vim-fugitive

return {
	"tpope/vim-fugitive",
	keys = function()
		local function open_git_status()
			local buf_id = vim.fn.bufnr("^fugitive://")
			-- Fugitive is already open, so just switch to it
			if buf_id ~= -1 then
				local win_ids = vim.fn.win_findbuf(buf_id)
				if #win_ids > 0 then
					vim.api.nvim_set_current_win(win_ids[1])
					return
				end
			end

			-- Fugitive is not open, so we need to open it
			vim.cmd("only") -- Make sure we are in a single window
			vim.cmd("vertical Git") -- Open Git status in a vertical split
			vim.cmd("wincmd L") -- Send current window (fugitive) to the right edge
		end

		local mappings = {
			{ "<leader>hst", open_git_status, "status" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Git")
	end,

	cmd = { "Git" },
	enabled = not vim.g.vscode,
}
