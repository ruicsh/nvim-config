-- Git diff hunks.
-- https://github.com/echasnovski/mini.diff

local icons = require("config/icons")

-- Make jump keymaps repeatable with `;` and `,`
local function set_keymaps_repeatable_jumps()
	local diff = require("mini.diff")

	local function jump_to_next()
		diff.goto_hunk("next")
	end
	local function jump_to_prev()
		diff.goto_hunk("prev")
	end

	local next, prev = vim.fn.make_repeatable_pair(jump_to_next, jump_to_prev)

	vim.keymap.set("n", "]h", next, { desc = "Next diff hunk" })
	vim.keymap.set("n", "[h", prev, { desc = "Previous diff hunk" })
end

return {
	"echasnovski/mini.diff",
	keys = function()
		local diff = require("mini.diff")

		local mappings = {
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
			apply = "gh",
			reset = "gH",
			textobject = "h",
			goto_first = "[H",
			goto_prev = "[h",
			goto_next = "]h",
			goto_last = "]H",
		},
	},
	config = function(_, opts)
		local diff = require("mini.diff")
		diff.setup(opts)

		set_keymaps_repeatable_jumps()
	end,

	event = "BufRead",
	enabled = not vim.g.vscode,
}
