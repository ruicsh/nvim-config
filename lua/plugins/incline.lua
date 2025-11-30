-- Floating winbar.
-- https://github.com/b0o/incline.nvim

return {
	"b0o/incline.nvim",
	opts = {
		hide = {
			cursorline = true,
		},
		render = function(props)
			local api = vim.api
			local bufnr = props.buf

			local grapple = require("grapple")
			local grapple_tag = grapple.exists({ buffer = bufnr }) and grapple.find({ buffer = bufnr })
			local grapple_part = {}

			if grapple_tag then
				grapple_part = {
					"󰛢" .. grapple_tag.name .. " ",
					group = "InclineGrapple",
				}
			end

			local bufname = api.nvim_buf_get_name(bufnr)
			local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or ""
			if api.nvim_buf_get_option(bufnr, "modified") then
				filename = filename .. " [+]"
			end

			return { grapple_part, filename }
		end,
	},

	dependencies = {
		"cbochs/grapple.nvim",
	},
}
