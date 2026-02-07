-- Floating winbar.
-- https://github.com/b0o/incline.nvim

local function c_lsp_diagnostics(props)
	local lines = {}

	local keys = { "error", "warning", "information", "hint" }
	for i, k in ipairs(keys) do
		local ki = vim.diagnostic.severity[i]
		local severity = vim.diagnostic.severity[ki]
		local count = vim.diagnostic.count(props.buf, { severity = severity })[severity]
		if count and count > 0 then
			local icon = k:sub(1, 1):upper()
			if k == "error" then
				local group = props.focused and "InclineLspDiagnosticsError" or "InclineSecondaryNC"
				table.insert(lines, { icon .. count .. " ", group = group })
			else
				local group = props.focused and "InclineSecondary" or "InclineSecondaryNC"
				table.insert(lines, { icon .. count .. " ", group = group })
			end
		end
	end

	return lines
end

local function c_filename(props)
	local lines = {}

	local devicons = require("nvim-web-devicons")

	local fullpath = vim.api.nvim_buf_get_name(props.buf)
	local filename = vim.fn.fnamemodify(fullpath, ":t")
	local relpath = vim.fn.fnamemodify(fullpath, ":~:.:h")
	local shortpath = relpath:match("([^/]+/[^/]+)$") or relpath
	local path = (shortpath and shortpath ~= ".") and shortpath or ""
	local icon, icon_color = devicons.get_icon(filename, nil, { default = true })

	table.insert(lines, { icon .. " ", group = icon_color })
	table.insert(lines, { filename .. " ", group = props.focused and "InclineNormal" or "InclineNormalNC" })
	if vim.bo[props.buf].modified then
		local group = props.focused and "InclineModified" or "InclineNormalNC"
		table.insert(lines, { "[+] ", group = group })
	end
	table.insert(lines, { path, group = props.focused and "InclineSecondary" or "InclineSecondaryNC" })

	return lines
end

return {
	"b0o/incline.nvim",
	opts = {
		hide = {
			cursorline = "focused_win",
		},
		render = function(props)
			return {
				c_lsp_diagnostics(props),
				c_filename(props),
			}
		end,
	},

	event = "VeryLazy",
}
