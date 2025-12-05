-- Window picker.
-- https://github.com/s1n7ax/nvim-window-picker

return {
	"s1n7ax/nvim-window-picker",
	keys = function()
		local picker = require("window-picker")

		local pick_window = function()
			local tabid = vim.api.nvim_get_current_tabpage()
			local wins = vim.api.nvim_tabpage_list_wins(tabid)

			local available = {}
			-- Filter out windows with excluded filetypes.
			for _, win in ipairs(wins) do
				local buf = vim.api.nvim_win_get_buf(win)
				local ft = vim.api.nvim_buf_get_option(buf, "filetype")
				if ft ~= "" and ft ~= "incline" and ft ~= "mininotify" then
					table.insert(available, win)
				end
			end

			-- Only one window, do nothing.
			if #available == 1 then
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

		local mappings = {
			{ "<bar>", pick_window, "Pick a window" },
			{ "<c-w>w", pick_window, "Pick a window" },
			{ "<c-w><c-w>", pick_window, "Pick a window" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Window Picker")
	end,
	opts = {
		filter_rules = {
			bo = {
				filetype = { "mininotify", "incline" },
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
