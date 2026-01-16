-- Window picker.
-- https://github.com/s1n7ax/nvim-window-picker

return {
	"s1n7ax/nvim-window-picker",
	keys = function()
		local picker = require("window-picker")

		local pick_window = function()
			local tabid = vim.api.nvim_get_current_tabpage()
			local wins = vim.api.nvim_tabpage_list_wins(tabid)

			-- Count only non-floating windows
			local available = {}
			for _, win in ipairs(wins) do
				local is_float = vim.api.nvim_win_get_config(win).relative ~= ""
				if not is_float then
					table.insert(available, win)
				end
			end

			-- Only one window, do nothing.
			if #available == 1 then
				-- If not already in the only available window, switch to it
				if available[1] ~= vim.api.nvim_get_current_win() then
					vim.api.nvim_set_current_win(available[1])
				end
				return
			end

			local picked_window_id
			if #available == 2 then
				-- If there are only two windows, automatically pick the other one.
				picked_window_id = picker.pick_window({
					filter_rules = {
						autoselect_one = true,
						include_current_win = false,
					},
				})
			elseif #available > 2 then
				-- Use the picker UI, with consistent labels
				picked_window_id = picker.pick_window({
					filter_rules = {
						include_current_win = true,
					},
				})
			end

			if picked_window_id then
				vim.api.nvim_set_current_win(picked_window_id)
			end
		end

		local function pick_floating_window()
			local tabid = vim.api.nvim_get_current_tabpage()
			local wins = vim.api.nvim_tabpage_list_wins(tabid)

			local DISABLED_FILETYPES = {
				"incline",
				"mininotify",
			}

			for _, winnr in ipairs(wins) do
				local bufnr = vim.api.nvim_win_get_buf(winnr)
				local ft = vim.bo[bufnr].filetype
				local is_float = vim.api.nvim_win_get_config(winnr).relative ~= ""
				local is_ts_context = vim.w[winnr].treesitter_context or vim.w[winnr].treesitter_context_line_number

				if is_float and not vim.tbl_contains(DISABLED_FILETYPES, ft) and not is_ts_context then
					vim.api.nvim_set_current_win(winnr)
					return
				end
			end
		end

		return {
			{ "<bar>", pick_window, desc = "Windows: Pick" },
			{ "<c-w>w", pick_window, desc = "Windows: Pick" },
			{ "<c-w><c-w>", pick_window, desc = "Windows: Pick" },
			{ "<c-w>W", pick_floating_window, desc = "Windows: Pick Floating" },
		}
	end,
	opts = {
		filter_rules = {
			bo = {
				filetype = { "incline", "mininotify" },
				buftype = { "nofile" },
			},
		},
		hint = "floating-big-letter",
		selection_chars = "asdfqwerzxcv",
		show_prompt = false,
	},

	name = "window-picker",
	event = "VeryLazy",
	version = "2.*",
}
