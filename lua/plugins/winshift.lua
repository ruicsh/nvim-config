-- Rearrange windows.
-- https://github.com/sindrets/winshift.nvim

return {
	"ruicsh/winshift.nvim",
	keys = {
		{ "<c-w>m", ":WinShift<cr>", desc = "Windows: Move" },
		{ "<c-w><c-m>", ":WinShift<cr>", desc = "Windows: Move" },
		{ "<c-w>x", ":WinShift swap<cr>", desc = "Windows: Swap" },
		{ "<c-w><c-x>", ":WinShift swap<cr>", desc = "Windows: Swap" },
	},
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
