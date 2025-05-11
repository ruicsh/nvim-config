-- Autocomplete
-- https://github.com/echasnovski/mini.completion

return {
	"echasnovski/mini.completion",
	keys = function()
		local function select_next()
			return vim.fn.pumvisible() == 1 and "<c-n>" or "<tab>"
		end

		local function select_previous()
			return vim.fn.pumvisible() == 1 and "<c-p>" or "<s-tab>"
		end

		local function accept()
			return vim.fn.complete_info()["selected"] ~= -1 and "<c-y>" or require("mini.pairs").cr()
		end

		local mappings = {
			{ "<tab>", select_next, "Select next", { mode = "i" } },
			{ "<s-tab>", select_previous, "Select previous", { mode = "i" } },
			{ "<cr>", accept, "Accept" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Autocomplete")
	end,
	opts = {
		mappings = {
			scroll_down = "<c-s-]>",
			scroll_up = "<c-s-[>",
		},
	},

	event = "VeryLazy",
	enabled = not vim.g.vscode,
}
