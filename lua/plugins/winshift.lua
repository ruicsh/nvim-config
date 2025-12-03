-- Rearrange windows.
-- https://github.com/sindrets/winshift.nvim

return {
	"sindrets/winshift.nvim",
	keys = function()
		local mappings = {
			{ "<c-w>m", "<cmd>WinShift<cr>", "Move" },
			{ "<c-w><c-m>", "<cmd>WinShift<cr>", "Move" },
			{ "<c-w>x", "<cmd>WinShift swap<cr>", "Swap" },
			{ "<c-w><c-x>", "<cmd>WinShift swap<cr>", "Swap" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Windows")
	end,
	opts = {
		focused_hl_group = "WinShiftFocused",
		disable_defaults = true,
		win_move_mode = {
			["h"] = "left",
			["j"] = "down",
			["k"] = "up",
			["l"] = "right",
			["H"] = "far_left",
			["J"] = "far_down",
			["K"] = "far_up",
			["L"] = "far_right",
		},
	},

	cmd = "WinShift",
}
