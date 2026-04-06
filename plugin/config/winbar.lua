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

local function has_right_side_panel()
	local half = math.floor(vim.o.columns * 0.5)
	for _, w in ipairs(vim.api.nvim_list_wins()) do
		local cfg = vim.api.nvim_win_get_config(w)
		if cfg.relative == "editor" and cfg.width >= half and cfg.col >= half then
			return true
		end
	end
	return false
end

local function visual_width(str)
	local plain = str:gsub("%%#[^#]*#", "")
	return vim.fn.strdisplaywidth(plain)
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

	local diagnostics = c_lsp_diagnostics(props)
	local filename = c_filename(props)

	local content = diagnostics .. filename .. " "
	local win_width = vim.api.nvim_win_get_width(winid)
	local half_screen = math.floor(vim.o.columns / 2)
	local needs_adjust = has_right_side_panel() and win_width > half_screen

	local width = visual_width(content)
	local target_col = needs_adjust and half_screen or win_width
	local padding = math.max(0, target_col - width)
	return string.rep(" ", padding) .. content
end

vim.api.nvim_create_autocmd({ "WinClosed", "WinNew" }, {
	group = vim.api.nvim_create_augroup("ruicsh/config/winbar", { clear = true }),
	callback = function()
		vim.schedule(function()
			vim.cmd("redrawstatus!")
		end)
	end,
})
