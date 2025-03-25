local M = {}

M = {
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
	servers = {
		["angularls@18.2.0"] = {
			filetypes = { "htmlangular", "typescript" },
		},
		cssls = {},
		cssmodules_ls = {},
		eslint = {},
		html = {},
		jsonls = {},
		lua_ls = {
			settings = {
				Lua = {
					diagnostics = {
						disable = { "missing-parameters", "missing-fields" },
					},
				},
			},
		},
		pyright = {
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "openFilesOnly",
						useLibraryCodeForTypes = true,
					},
				},
			},
		},
		rust_analyzer = {},
		vuels = {},
	},
	tools = {
		black = {},
		codelldb = {},
		flake8 = {},
		prettierd = {},
		pylint = {},
		stylua = {},
	},
	handlers = {
		["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
			cache = true,
			focus = true,
			max_width = 80,
			update_in_insert = false,
		}),
		["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
			focus = true,
			max_width = 80,
		}),
	},
}

return M
