-- Auto resize splits when window is resized

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/auto-resize-splits", { clear = true })

-- Windows terminals emit VimResized continuously while the window is dragged,
-- and each one would resize every window in every tab.
local DEBOUNCE_MS = 150

local timer = nil

local function resize_splits()
	local current_tab = vim.api.nvim_get_current_tabpage()
	vim.cmd("tabdo wincmd =") -- Resize all windows on all tabs
	vim.api.nvim_set_current_tabpage(current_tab)
end

vim.api.nvim_create_autocmd("VimResized", {
	group = augroup,
	callback = function()
		if timer then
			timer:stop()
			timer:close()
		end

		timer = vim.uv.new_timer()
		timer:start(DEBOUNCE_MS, 0, function()
			timer:stop()
			timer:close()
			timer = nil
			vim.schedule(resize_splits)
		end)
	end,
})
