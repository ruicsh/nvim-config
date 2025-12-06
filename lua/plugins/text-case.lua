-- Convert between different text cases
-- https://github.com/johmsalas/text-case.nvim

return {
	"ruicsh/text-case.nvim",
	keys = function()
		local tc = require("textcase")

		local function current_word(op)
			return function()
				tc.current_word(op)
			end
		end

		local function lsp_rename(op)
			return function()
				tc.lsp_rename(op)
			end
		end

		local function operator(op)
			return function()
				tc.operator(op)
			end
		end

		local prefix_cw = "ga"
		local prefix_lsp = "<leader>ga"
		local prefix_op = "gao"

		local mappings = {
			{ prefix_cw .. "-", current_word("to_dash_case"), "Dash", { mode = { "n", "x" } } },
			{ prefix_cw .. "_", current_word("to_snake_case"), "Snake", { mode = { "n", "x" } } },
			{ prefix_cw .. "C", current_word("to_constant_case"), "Constant", { mode = { "n", "x" } } },
			{ prefix_cw .. "U", current_word("to_upper_case"), "Upper", { mode = { "n", "x" } } },
			{ prefix_cw .. "c", current_word("to_camel_case"), "Camel", { mode = { "n", "x" } } },
			{ prefix_cw .. "p", current_word("to_pascal_case"), "Pascal", { mode = { "n", "x" } } },
			{ prefix_cw .. "u", current_word("to_lower_case"), "Lower", { mode = { "n", "x" } } },

			{ prefix_lsp .. "-", lsp_rename("to_dash_case"), "Dash", { mode = { "n", "v" } } },
			{ prefix_lsp .. "_", lsp_rename("to_snake_case"), "Snake", { mode = { "n", "v" } } },
			{ prefix_lsp .. "C", lsp_rename("to_constant_case"), "Constant", { mode = { "n", "v" } } },
			{ prefix_lsp .. "U", lsp_rename("to_upper_case"), "Upper", { mode = { "n", "v" } } },
			{ prefix_lsp .. "c", lsp_rename("to_camel_case"), "Camel", { mode = { "n", "v" } } },
			{ prefix_lsp .. "p", lsp_rename("to_pascal_case"), "Pascal", { mode = { "n", "v" } } },
			{ prefix_lsp .. "u", lsp_rename("to_lower_case"), "Lower", { mode = { "n", "v" } } },

			{ prefix_op .. "-", operator("to_dash_case"), "Dash" },
			{ prefix_op .. "_", operator("to_snake_case"), "Snake" },
			{ prefix_op .. "C", operator("to_constant_case"), "Constant" },
			{ prefix_op .. "U", operator("to_upper_case"), "Upper" },
			{ prefix_op .. "c", operator("to_camel_case"), "Camel" },
			{ prefix_op .. "p", operator("to_pascal_case"), "Pascal" },
			{ prefix_op .. "u", operator("to_lower_case"), "Lower" },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Text Case")
	end,
	opts = {
		default_keymappings_enabled = false,
	},
}
