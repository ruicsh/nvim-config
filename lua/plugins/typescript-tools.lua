-- TypeScript LSP (tsserver)
-- https://github.com/pmizio/typescript-tools.nvim

return {
	"pmizio/typescript-tools.nvim",
	keys = function()
		local mappings = {
			{ "<leader>tsa", ":TSToolsAddMissingImports<cr>", "Add missing imports" },
			{ "<leader>tsd", ":TSToolsGoToSourceDefinition<cr>", "Go to source [d]efinition" },
			{ "<leader>tso", ":TSToolsOrganizeImports<cr>", "Organize imports" },
			{ "<leader>tsr", ":TSToolsRenameFile<cr>", "[r]ename [f]ile" },
			{ "<leader>tss", ":TSToolsSortImports<cr>", "Sort imports" },
			{ "<leader>tsu", ":TSToolsRemoveUnusedImports<cr>", "Remove unused imports" },
		}

		return vim.tbl_map(function(mapping)
			local lhs = mapping[1]
			local rhs = mapping[2]
			local desc = "TypeScript: " .. mapping[3]
			return { lhs, rhs, silent = true, noremap = true, unique = true, desc = desc }
		end, mappings)
	end,
	opts = {
		settings = {
			tsserver_file_preferences = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
			},
		},
	},

	ft = { "typescript", "typescriptreact" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"neovim/nvim-lspconfig",
	},
}