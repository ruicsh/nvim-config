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
			{ "<leader><leader>", snacks.picker.files, "Search: Files" },
			{ "<leader>f", snacks.picker.grep, "Search: Workspace" },
			{ "<leader>,", snacks.picker.buffers, "Search: Buffers" },
			{ "<leader>j", snacks.picker.jumps, "Search: Jumplist" },
			{ "<leader>nh", snacks.picker.help, "Search: Help" },
			{ "<leader>nc", snacks.picker.commands, "Search: Commands" },
			{ "<leader>nk", snacks.picker.keymaps, "Search: Keymaps" },
			{ "<leader>no", snacks.notifier.show_history, "Notifications: Show history" },
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
		-- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
		notifier = {
			enabled = true,
			level = vim.log.levels.ERROR,
		},
		-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
		picker = {
			enabled = true,
			formatters = {
				file = {
					filename_first = true,
				},
			},
			sources = {
				buffers = {
					win = {
						input = {
							keys = {
								["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
							},
						},
						list = {
							keys = {
								["<c-d>"] = "bufdelete",
							},
						},
					},
				},
			},
		},
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

	lazy = false,
}
