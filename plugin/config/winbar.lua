-- Winbar configuration

local T = require("lib")

-- Hoist require out of the hot render path
local devicons = require("nvim-web-devicons")

local function c_lsp_diagnostics(props)
	local bufnr = props.bufnr
	local focused = props.focused

	local counts = T.fn.diagnostic_counts(bufnr)
	local parts = {}

	for _, entry in ipairs(counts) do
		local icon = entry.key:sub(1, 1):upper()
		local group = "WinbarSecondaryNC"
		if entry.key == "error" then
			group = focused and "WinbarLspDiagnosticsError" or group
		else
			group = focused and "WinbarSecondary" or group
		end
		table.insert(parts, "%#" .. group .. "#" .. icon .. entry.count .. " ")
	end

	return table.concat(parts)
end

local function c_filename(props)
	local bufnr = props.bufnr
	local modified = props.modified
	local focused = props.focused

	local fullpath = vim.api.nvim_buf_get_name(bufnr)
	if fullpath == "" then
		return ""
	end

	local filename = vim.fn.fnamemodify(fullpath, ":t")
	local relpath = vim.fn.fnamemodify(fullpath, ":~:.:h")
	local shortpath = relpath:match("([^/]+/[^/]+)$") or relpath
	local path = (shortpath and shortpath ~= ".") and shortpath or ""
	local icon, icon_color = devicons.get_icon(filename, nil, { default = true })

	local parts = {}

	if icon and icon_color then
		table.insert(parts, "%#" .. icon_color .. "#" .. icon .. " ")
	end
	local group = focused and "WinbarNormal" or "WinbarNormalNC"
	table.insert(parts, "%#" .. group .. "#" .. filename)

	if modified then
		group = focused and "WinbarModified" or "WinbarNormalNC"
		table.insert(parts, " %#" .. group .. "#[+]")
	end

	if path ~= "" then
		group = focused and "WinbarSecondary" or "WinbarSecondaryNC"
		table.insert(parts, " %#" .. group .. "#" .. path)
	end

	return table.concat(parts)
end

function _G.winbar()
	local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()
	local bufnr = vim.api.nvim_win_get_buf(winid)
	local modified = vim.bo[bufnr].modified and true or false

	local props = {
		bufnr = bufnr,
		focused = vim.api.nvim_get_current_win() == winid,
		modified = modified,
	}

	return table.concat({
		"%=",
		c_lsp_diagnostics(props),
		c_filename(props),
		" ",
	})
end
