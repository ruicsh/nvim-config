-- Git client
-- https://github.com/tpope/vim-fugitive

local augroup = vim.api.nvim_create_augroup("ruicsh/plugin/fugitive", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = "fugitive://*",
	callback = function()
		-- Needs to be here because the ftplugin is loaded before these are set
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "yes:2"
	end,
})

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

		local function open_git_log()
			-- Fugitive is not open, so we need to open it
			vim.cmd("only") -- Make sure we are in a single window
			vim.cmd("vertical Git log") -- Open Git log in a vertical split
			vim.cmd("wincmd L") -- Send current window (fugitive) to the right edge
		end

		local mappings = {
			{ "<leader>hh", open_git_status, "status" },
			{ "<leader>hl", open_git_log, "log" },
			{ "<leader>hb", "<cmd>Git blame<cr>", "blame" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Git")
	end,

	cmd = { "Git" },
}
