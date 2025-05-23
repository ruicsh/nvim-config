-- LSP references navigation.
-- https://github.com/folke/snacks.nvim/blob/main/docs/words.md

return {
	"folke/snacks.nvim",
	keys = (function()
		local words = require("snacks.words")

		local function jump_to_previous_reference()
			words.jump(-1, true)
		end

		local function jump_to_next_reference()
			words.jump(1, true)
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

	event = "LspAttach",
	enabled = not vim.g.vscode,
}
