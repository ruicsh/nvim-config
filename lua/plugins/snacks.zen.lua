-- Distraction-free
-- https://github.com/folke/snacks.nvim/blob/main/docs/zen.md

local old_keymap

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local mappings = {
			{ "<leader>z", snacks.zen.zen, "Toggle" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Zen mode")
	end)(),
	opts = {
		zen = {
			enabled = true,
			on_close = function()
				-- Restore the old keymap for <c-]>
				if old_keymap then
					vim.keymap.del("n", "<c-]>", { buffer = true })
					if old_keymap.rhs then
						vim.api.nvim_set_keymap("n", "<c-]>", old_keymap.rhs, {
							buffer = true,
							silent = old_keymap.silent == 1,
							expr = old_keymap.expr == 1,
							replace = true,
						})
					end
					old_keymap = nil
				end
			end,
			on_open = function()
				local snacks = require("snacks")
				-- Save the current keymap for <c-]>
				old_keymap = vim.fn.maparg("<c-]>", "n", false, true)
				vim.keymap.set("n", "<c-]>", snacks.zen.zen, { buffer = true })
			end,
			toggles = {
				dim = false,
			},
			win = {
				width = 120,
				wo = {
					wrap = true,
				},
			},
		},
	},

	enabled = not vim.g.vscode,
}
