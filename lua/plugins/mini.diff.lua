-- In-buffer inline diff, VSCode style.
-- https://github.com/nvim-mini/mini.diff

return {
	"nvim-mini/mini.diff",
	init = function()
		-- Block setup()'s initial auto-enable of already-open buffers.
		vim.g.minidiff_disable = true
	end,
	config = function(_, opts)
		require("mini.diff").setup(opts)
		-- setup() installs a BufEnter autocmd that auto-enables every buffer.
		-- Drop it: we attach one buffer on demand, in toggle_overlay.
		vim.api.nvim_clear_autocmds({ group = "MiniDiff", event = "BufEnter" })
	end,
	keys = function()
		local function any_overlay_open()
			local diff = require("mini.diff")
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				local data = diff.get_buf_data(buf)
				if data and data.overlay then
					return true
				end
			end
			return false
		end

		local function toggle_overlay()
			local diff = require("mini.diff")
			local data = diff.get_buf_data()

			if not data then
				-- enable() refuses disabled buffers, so lift the flag to attach.
				vim.g.minidiff_disable = false
				diff.enable()
				data = diff.get_buf_data()
				if not data then
					vim.g.minidiff_disable = true
					vim.notify("Inline diff unavailable for this buffer", vim.log.levels.WARN)
					return
				end
			end

			if data.overlay then
				diff.toggle_overlay() -- off
				diff.disable() -- stop background diffing for this buffer
				-- Keep the flag lifted while any overlay is still open elsewhere.
				if not any_overlay_open() then
					vim.g.minidiff_disable = true
				end
			else
				-- Stay lifted so diff updates keep running while the overlay is on.
				vim.g.minidiff_disable = false
				diff.toggle_overlay() -- on
			end
		end

		return {
			{ "<leader>hd", toggle_overlay, desc = "Git: Inline diff overlay" },
		}
	end,
	opts = {
		-- gitsigns owns the sign column: mini.diff only contributes the overlay.
		view = { style = "sign", signs = { add = " ", change = " ", delete = " " } },
		-- gitsigns already does staging, resetting, and ]c/[c navigation.
		mappings = {
			apply = "",
			reset = "",
			textobject = "",
			goto_first = "",
			goto_prev = "",
			goto_next = "",
			goto_last = "",
		},
	},
}
