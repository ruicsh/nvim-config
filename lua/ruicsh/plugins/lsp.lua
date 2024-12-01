-- LSP config
-- https://github.com/neovim/nvim-lspconfig

local config = require("ruicsh/config")

return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Diagnostics
		vim.diagnostic.config({
			float = {
				border = "rounded",
				prefix = function(diagnostic)
					local icons = {
						config.icons.diagnostics.Error,
						config.icons.diagnostics.Warn,
						config.icons.diagnostics.Info,
						config.icons.diagnostics.Hint,
					}
					local hl = {
						"DiagnosticSignError",
						"DiagnosticSignWarn",
						"DiagnosticSignInfo",
						"DiagnosticSignHint",
					}
					return icons[diagnostic.severity], hl[diagnostic.severity]
				end,
			},
			severity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = config.icons.diagnostics.Error,
					[vim.diagnostic.severity.WARN] = config.icons.diagnostics.Warn,
					[vim.diagnostic.severity.INFO] = config.icons.diagnostics.Info,
					[vim.diagnostic.severity.HINT] = config.icons.diagnostics.Hint,
					[vim.diagnostic.severity.N] = config.icons.diagnostics.Hint,
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
					[vim.diagnostic.severity.N] = "DiagnosticSignInfo",
				},
			},
			virtual_text = {
				prefix = "",
				severity = vim.diagnostic.severity.ERROR,
			},
		})

		-- LSP servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		require("mason").setup()

		require("mason-tool-installer").setup({
			run_on_start = true,
			ensure_installed = vim.tbl_keys(config.lsp.tools or {}),
		})

		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(config.lsp.servers or {}),
			automatic_installation = true,
			handlers = {
				function(server_name)
					local server = config.lsp.servers[server_name] or {}

					local conf = vim.tbl_deep_extend("force", server, {
						capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {}),
						handlers = {
							-- <s-k> float window
							["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
								border = "rounded",
								focusable = false,
								focus = false,
							}),
							-- i_<c-k> float window
							["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
								border = "rounded",
								focusable = false,
								focus = false,
							}),
						},
						on_attach = function(client, bufnr)
							if client.server_capabilities.documentSymbolProvider then
								-- Add navic to barbecue
								require("nvim-navic").attach(client, bufnr)
							end

							-- Highlight all references to symbol under cursor
							if client.server_capabilities.documentHighlightProvider then
								local group =
									vim.api.nvim_create_augroup("ruicsh/lsp_document_highlight", { clear = true })
								vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })

								vim.api.nvim_create_autocmd("CursorHold", {
									callback = vim.lsp.buf.document_highlight,
									buffer = bufnr,
									group = group,
									desc = "Document highlight",
								})

								vim.api.nvim_create_autocmd("CursorMoved", {
									callback = vim.lsp.buf.clear_references,
									buffer = bufnr,
									group = group,
									desc = "Clear all reference highlights",
								})
							end
						end,
					})

					require("lspconfig")[server_name].setup(conf)
				end,
			},
		})

		-- Keymaps
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("ruicsh/lsp_keymaps", { clear = true }),
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if not client then
					return
				end

				local k = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				local function jump_to_definition()
					vim.lsp.buf.definition()
					vim.cmd.normal("zz")
				end

				local function jump_to_type_definition()
					vim.lsp.buf.type_definition()
					vim.cmd.normal("zz")
				end

				local function document_symbol()
					vim.cmd("Outline")
				end

				-- https://neovim.io/doc/user/lsp.html#lsp-defaults
				k("gd", jump_to_definition, "Jump to [d]efinition")
				k("gD", vim.lsp.buf.declaration, "Jump to [D]eclaration")
				k("gO", document_symbol, "Document Symbol")
				k("gra", vim.lsp.buf.code_action, "Code actions", { "n", "v" })
				k("grt", jump_to_type_definition, "Jump to type definition")
				k("gri", vim.lsp.buf.implementation, "List [i]mplementations")
				k("grj", vim.lsp.buf.incoming_calls, "Incoming calls")
				k("grk", vim.lsp.buf.outgoing_calls, "Outgoing calls")
				k("grn", vim.lsp.buf.rename, "Rename symbol")
				k("grr", vim.lsp.buf.references, "List [r]eferences")
				k("<c-s>", vim.lsp.buf.signature_help, "Signature help", { "n", "i" })
				k("<leader>xx", vim.diagnostic.setqflist, "Diagnostics")
			end,
		})
	end,

	dependencies = {
		{ -- Install LSP servers
			-- https://github.com/williamboman/mason.nvim
			"williamboman/mason.nvim",
		},
		{ -- Install and upgrade 3rd party tools
			-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		{ -- Easier to use lspconfig with mason
			-- https://github.com/williamboman/mason-lspconfig.nvim
			"williamboman/mason-lspconfig.nvim",
		},
		{ -- TypeScript integration
			-- https://github.com/pmizio/typescript-tools.nvim
			"pmizio/typescript-tools.nvim",
			opts = {},
		},
		{ "onsails/lspkind.nvim" },
		{ "hrsh7th/cmp-nvim-lsp" },
	},
}
