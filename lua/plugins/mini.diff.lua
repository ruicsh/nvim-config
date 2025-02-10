-- Git diff hunks.
-- https://github.com/echasnovski/mini.diff

local icons = require("config/icons")

return {
	"echasnovski/mini.diff",
	keys = function()
		local diff = require("mini.diff")

		local function operator(mode)
			return function()
				return diff.operator(mode) .. "h"
			end
		end

		local mappings = {
			{ "gh", operator("apply"), "Stage hunk", { expr = true, remap = true } },
			{ "gH", operator("reset"), "Reset hunk", { expr = true, remap = true } },
			{ "<leader>hd", diff.toggle_overlay, "Toggle diff overlay" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Git")
	end,
	opts = {
		view = {
			style = "sign",
			signs = {
				add = icons.git.Add,
				change = icons.git.Change,
				delete = icons.git.Delete,
			},
		},
		mappings = {
			apply = "",
			reset = "",
			textobject = "h",
		},
	},

	event = { "VeryLazy" },
}
