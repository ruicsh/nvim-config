-- Floating winbar.
-- https://github.com/b0o/incline.nvim

return {
	"b0o/incline.nvim",
	opts = {
		hide = {
			cursorline = true,
		},
		render = function(props)
			local devicons = require("nvim-web-devicons")

			local fullpath = vim.api.nvim_buf_get_name(props.buf)
			local filename = vim.fn.fnamemodify(fullpath, ":t")
			local relpath = vim.fn.fnamemodify(fullpath, ":~:.:h")
			local shortpath = relpath:match("([^/]+/[^/]+)$") or relpath
			local path = (shortpath and shortpath ~= ".") and shortpath or ""
			local modified = vim.bo[props.buf].modified

			local icon, icon_color = devicons.get_icon(filename, nil, { default = true })

			return {
				{ icon .. " ", group = icon_color },
				{ filename .. " ", group = props.focused and "InclineNormal" or "InclineNormalNC" },
				modified and { "[+] ", group = "InclineModified" } or "",
				{ path, group = props.focused and "InclinePath" or "InclinePathNC" },
			}
		end,
	},

	event = "VeryLazy",
}
