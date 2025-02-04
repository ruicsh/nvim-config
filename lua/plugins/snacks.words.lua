-- LSP references navigation.
-- https://github.com/folke/snacks.nvim/blob/main/docs/words.md

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local function jump_to_previous_reference()
			snacks.words.jump(-1, true)
		end

		local function jump_to_next_reference()
			snacks.words.jump(1, true)
		end

		local mappings = {
			{ "[r", jump_to_previous_reference, "LSP: Jump to previous reference" },
			{ "]r", jump_to_next_reference, "LSP: Jump to next reference" },
		}
		return vim.fn.get_lazy_keys_conf(mappings)
	end)(),
	opts = {
		words = {
			enabled = true,
		},
	},

	lazy = false,
}
