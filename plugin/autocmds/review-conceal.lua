-- Show concealed Tailwind class lists while reviewing diffs.
-- `queries/*/highlights.scm` collapses `class="..."` behind `conceallevel = 1`
-- (see `after/ftplugin/html.lua`), which hides exactly what a diff is showing.
-- Reveal it in review windows only; normal editing keeps the conceal.

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/review-conceal", { clear = true })

local function in_review_window(win)
	-- fugitive's :Gdiffsplit sets 'diff' in its own windows only.
	if vim.wo[win].diff then
		return true
	end
	-- codediff flags each of its panes, and the flag outlives file switches.
	return vim.w[win].codediff_restore == 1
end

-- Deferred because both clients mark their review windows after the buffer is
-- already displayed in them.
local function sync(win)
	vim.schedule(function()
		if not vim.api.nvim_win_is_valid(win) then
			return
		end

		local saved = vim.w[win].review_conceal_saved
		if in_review_window(win) then
			if saved == nil then
				vim.w[win].review_conceal_saved = vim.wo[win].conceallevel
			end
			vim.wo[win].conceallevel = 0
		elseif saved ~= nil then
			vim.wo[win].conceallevel = saved
			vim.w[win].review_conceal_saved = nil
		end
	end)
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
	group = augroup,
	callback = function()
		sync(vim.api.nvim_get_current_win())
	end,
})

-- codediff creates the session, and flags its panes, only after the files have
-- been loaded in them.
vim.api.nvim_create_autocmd("User", {
	group = augroup,
	pattern = "CodeDiffOpen",
	callback = function(ev)
		local ok, lifecycle = pcall(require, "codediff.ui.lifecycle")
		if not ok then
			return
		end

		local original_win, modified_win = lifecycle.get_windows(ev.data.tabpage)
		for _, win in ipairs({ original_win, modified_win }) do
			if win and vim.api.nvim_win_is_valid(win) then
				sync(win)
			end
		end
	end,
})
