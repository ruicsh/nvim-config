-- Dim inactive windows.

local group = vim.api.nvim_create_augroup("ruicsh/dim_inactive_windows", { clear = true })

-- Compose the inactive window highlight group on entering vim
local inactive_winhighlight = ""
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = group,
	callback = function()
		local highlights = {}

		-- set all highlight groups to hl_InactiveWindow
		for hl, _ in pairs(vim.api.nvim_get_hl(0, {})) do
			table.insert(highlights, hl .. ":DimInactiveWindow")
		end

		-- some elements are dimmer
		local dimmer = { "SnacksIndent" }
		for _, hl in pairs(dimmer) do
			table.insert(highlights, hl .. ":DimInactiveWindowDimmer")
		end

		-- store it for use when leaving windows
		inactive_winhighlight = table.concat(highlights, ",")
	end,
})

-- Store settings per window to use when re-entering
local settings_by_window = {}

vim.api.nvim_create_autocmd({ "WinLeave" }, {
	group = group,
	callback = function()
		-- init a cache for this window settings
		local winid = vim.api.nvim_win_get_number(0)
		local cached = settings_by_window[winid] or {}
		settings_by_window[winid] = cached

		vim.wo.winhighlight = inactive_winhighlight
		vim.cmd("ColorizerToggle") -- don't highlight CSS colors

		cached.spell = vim.wo.spell -- store it for use on re-enter
		vim.wo.spell = false
	end,
})

vim.api.nvim_create_autocmd({ "WinEnter" }, {
	group = group,
	callback = function()
		local winid = vim.api.nvim_win_get_number(0)
		local cached = settings_by_window[winid] or {}

		vim.wo.winhighlight = ""
		vim.cmd("ColorizerToggle") -- turn it back on

		vim.wo.spell = cached.spell -- toggle back to spelling (or not)
	end,
})
