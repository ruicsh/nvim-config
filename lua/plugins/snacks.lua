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

		local mappings = {
			{ "<leader><space>", snacks.picker.files, "Find files" },
			{ "<leader>f", snacks.picker.grep, "Search: workspace" },
			{ "<leader>.", snacks.picker.resume, "Search: Last search" },
			{ "<leader>nh", snacks.picker.help, "Search: Help" },
			{ "<leader>nc", snacks.picker.commands, "Search: Commands" },
			{ "<leader>nk", snacks.picker.keymaps, "Search: Keymaps" },
			{ "[r", jump_to_previous_reference, "LSP: Jump to previous reference" },
			{ "]r", jump_to_next_reference, "LSP: Jump to next reference" },
		}
		return vim.fn.getlazykeysconf(mappings)
	end,
	opts = {
		-- https://github.com/folke/snacks.nvim/blob/main/docs/bufdelete.md
		bufdelete = {
			enabled = true,
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
		-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
		picker = {},
		-- https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md
		statuscolumn = {
			left = { "sign", "git" },
			right = { "mark", "fold" },
		},
		-- https://github.com/folke/snacks.nvim/blob/main/docs/words.md
		words = {
			enabled = true,
		},
	},

	event = { "VeryLazy" },
}
