-- Git client
-- https://github.com/tpope/vim-fugitive

return {
	"tpope/vim-fugitive",
	keys = function()
		local function open_git_status()
			-- Fugitive is already open, so just switch to it
			local buf_id = vim.fn.bufnr("^fugitive://")
			if buf_id ~= -1 then
				local win_ids = vim.fn.win_findbuf(buf_id)
				if #win_ids > 0 then
					vim.api.nvim_set_current_win(win_ids[1])
					return
				end
			end

			-- Fugitive is not open, so we need to open it
			vim.ux.open_side_panel("vertical Git")
		end

		local mappings = {
			{ "<leader>hh", open_git_status, "status" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Git")
	end,

	event = "VeryLazy",
	enabled = not vim.g.vscode,
}
