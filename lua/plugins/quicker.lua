-- Quickfix/location list formatter
-- https://github.com/stevearc/quicker.nvim

local icons = require("config/icons")

return {
	"stevearc/quicker.nvim",
	keys = function()
		local quicker = require("quicker")

		local function toggle_quickfix()
			quicker.toggle({ focus = true })
		end

		local function toggle_loclist()
			quicker.toggle({ loclist = true })
		end

		local mappings = {
			{ "<leader>qq", toggle_quickfix, "Toggle" },
			{ "<leader>ql", toggle_loclist, "Toggle locklist" },
		}
		return vim.fn.getlazykeysconf(mappings, "Quickfix")
	end,
	opts = {
		opts = {
			buflisted = false,
			number = true,
			relativenumber = false,
			signcolumn = "yes",
			winfixheight = true,
			wrap = false,
		},
		use_default_opts = false,
		type_icons = {
			E = icons.diagnostics.Error,
			W = icons.diagnostics.Warn,
			I = icons.diagnostics.Info,
			N = icons.diagnostics.Hint,
			H = icons.diagnostics.Hint,
		},
		max_filename_width = function()
			return math.floor(math.min(95, vim.o.columns / 3))
		end,
		constrain_cursor = false,
	},

	ft = { "qf" },
}
