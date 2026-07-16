-- Session management
-- https://github.com/rmagatti/auto-session

local is_rebasing = require("lib.git").is_rebasing

return {
	"rmagatti/auto-session",
	event = "VimEnter",
	opts = {
		close_filetypes_on_save = { "checkhealth", "fugitive", "git", "gitcommit", "terminal" },
		git_auto_restore_on_branch_change = true,
		git_use_branch_name = true,
		purge_after_minutes = 14400,
		pre_save_cmds = {
			function()
				if is_rebasing() then
					return false
				end
			end,
		},
		pre_restore_cmds = {
			function()
				if is_rebasing() then
					return false
				end
			end,
		},
		save_extra_cmds = {
			-- Save and restore the quickfix list
			function()
				local qflist = vim.fn.getqflist()
				-- Return nil to clear any old qflist
				if #qflist == 0 then
					return nil
				end

				local qfinfo = vim.fn.getqflist({ title = 1 })
				for _, entry in ipairs(qflist) do
					-- Use filename instead of bufnr so it can be reloaded
					entry.filename = vim.api.nvim_buf_get_name(entry.bufnr)
					entry.bufnr = nil
				end

				local setqflist = "call setqflist(" .. vim.fn.string(qflist) .. ")"
				local setqfinfo = 'call setqflist([], "a", ' .. vim.fn.string(qfinfo) .. ")"

				return { setqflist, setqfinfo }
			end,
		},
		suppressed_dirs = { "~/", "~/Downloads", "/" },
	},
}
