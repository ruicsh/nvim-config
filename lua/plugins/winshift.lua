-- Rearrange windows.
-- https://github.com/sindrets/winshift.nvim

return {
	"ruicsh/winshift.nvim",
	keys = function()
		local mappings = {
			{ "<c-w>m", "<cmd>WinShift<cr>", "Move" },
			{ "<c-w><c-m>", "<cmd>WinShift<cr>", "Move" },
			{ "<c-w>x", "<cmd>WinShift swap<cr>", "Swap" },
			{ "<c-w><c-x>", "<cmd>WinShift swap<cr>", "Swap" },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Windows")
	end,
	opts = {
		focused_hl_group = "WinShiftFocused",
		window_picker_hl_group = "WinShiftWindowPicker",
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
		after_swap = function()
			-- Equalize window sizes after a swap
			vim.cmd("wincmd =")
		end,
	},

	cmd = "WinShift",
}
