-- Dim inactive windows.

local augroup = vim.api.nvim_create_augroup("ruicsh/dim_inactive_windows", { clear = true })

local function ignore_window()
	if vim.wo.diff or vim.wo.previewwindow then
		return true
	end

	local ft = vim.bo.filetype
	return ft == "qf" or ft:match("Diffview")
end

-- Compose the inactive window highlight group on entering vim
local inactive_winhighlight = ""
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = augroup,
	callback = function()
		local highlights = {}

		-- set all highlight groups to hl_DimInactiveWindows
		for hl, _ in pairs(vim.api.nvim_get_hl(0, {})) do
			table.insert(highlights, hl .. ":DimInactiveWindowsText500")
		end

		-- some elements are dimmer
		local dimmer = { "SnacksIndent" }
		for _, hl in pairs(dimmer) do
			table.insert(highlights, hl .. ":DimInactiveWindowsText900")
		end

		-- store it for use when leaving windows
		inactive_winhighlight = table.concat(highlights, ",")
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
	group = augroup,
	callback = function()
		if ignore_window() then
			return
		end

		vim.schedule(function()
			-- only dim inactive windows if there is no diff
			if vim.fn.isdiffopen() then
				vim.wo.winhighlight = ""
			end
		end)

		vim.wo.winhighlight = inactive_winhighlight
		vim.cmd("ColorizerDetachFromBuffer") -- don't highlight CSS colors
		vim.wo.spell = false -- turn spelling off
	end,
})

vim.api.nvim_create_autocmd({ "WinEnter" }, {
	group = augroup,
	callback = function()
		if ignore_window() then
			return
		end

		local ft = vim.bo.filetype

		vim.wo.winhighlight = ""
		vim.cmd("ColorizerAttachToBuffer") -- turn it back on

		-- if text files switch spell back on
		if ft == "markdown" or ft == "text" or ft == "gitcommit" then
			vim.wo.spell = true
		end
	end,
})
