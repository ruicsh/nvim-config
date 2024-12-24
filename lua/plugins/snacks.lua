-- Small QoL plugins.
-- https://github.com/folke/snacks.nvim

return {
	"folke/snacks.nvim",
	keys = function()
		local snacks = require("snacks")

		local function jump_to_previous_reference()
			snacks.words.jump(-1, true)
		end

		local function jump_to_next_reference()
			snacks.words.jump(1, true)
		end

		return {
			{ "[r", jump_to_previous_reference, { desc = "LSP: Jump to previous reference" } },
			{ "]r", jump_to_next_reference, { desc = "LSP: Jump to next reference" } },
		}
	end,
	opts = {
		-- https://github.com/folke/snacks.nvim/blob/main/docs/bufdelete.md
		bufdelete = {
			enabled = true,
		},
		-- https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md
		statuscolumn = {
			left = { "sign", "git" },
			right = { "mark", "fold" },
		},
		-- https://github.com/folke/snacks.nvim/blob/main/docs/indent.md
		indent = {
			animate = {
				enabled = false,
			},
			scope = {
				only_current = true,
			},
		},
		-- https://github.com/folke/snacks.nvim/blob/main/docs/words.md
		words = {
			enabled = true,
		},
	},

	event = { "VeryLazy" },
}
