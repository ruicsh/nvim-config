-- Autocmds for LSP attach/detach events

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/lsp-attach", { clear = true })

local icons = require("config/icons")
local lspconf = require("config/lsp")

-- Configure diagnostics
local function diagnostics()
	vim.diagnostic.config({
		float = {
			border = "rounded",
			prefix = function(diagnostic)
				local iconsMap = {
					Error = icons.diagnostics.error,
					Warn = icons.diagnostics.warning,
					Info = icons.diagnostics.information,
					Hint = icons.diagnostics.hint,
				}
				local hl = {
					"DiagnosticSignError",
					"DiagnosticSignWarn",
					"DiagnosticSignInfo",
					"DiagnosticSignHint",
				}
				return iconsMap[diagnostic.severity], hl[diagnostic.severity]
			end,
		},
		severity_sort = true,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
				[vim.diagnostic.severity.WARN] = icons.diagnostics.warning,
				[vim.diagnostic.severity.INFO] = icons.diagnostics.information,
				[vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
				[vim.diagnostic.severity.N] = icons.diagnostics.hint,
			},
			numhl = {
				[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
				[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
				[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
				[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				[vim.diagnostic.severity.N] = "DiagnosticSignInfo",
			},
		},
		underline = true,
		update_in_insert = false,
		virtual_lines = true,
		virtual_text = {
			spacing = 4,
			source = "if_many",
			prefix = "●",
			severity = vim.diagnostic.severity.ERROR,
		},
	})

	-- Disable diagnostics if env var is set
	if vim.fn.getenv("DISABLE_LSP_DIAGNOSTICS") == "true" then
		vim.diagnostic.enable(false)
	end
end

-- Set keymaps for LSP
local function keymaps(bufnr, client)
	local snacks = require("snacks")

	local k = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end
	local methods = vim.lsp.protocol.Methods

	-- https://neovim.io/doc/user/lsp.html#lsp-defaults
	k("gO", snacks.picker.lsp_symbols, "LSP: Symbols")
	k("<leader>dd", vim.diagnostic.setqflist, "Diagnostics")

	if client.supports_method(methods.textDocument_definition) then
		k("gd", vim.lsp.buf.definition, "Jump to [d]efinition")
	end
	if client.supports_method(methods.textDocument_declaration) then
		k("gD", vim.lsp.buf.declaration, "Jump to [D]eclaration")
	end
	if client.supports_method(methods.textDocument_typeDefinition) then
		k("grt", vim.lsp.buf.type_definition, "Jump to type definition")
	end
	if client.supports_method(methods.callHierarchy_incomingCalls) then
		k("grj", vim.lsp.buf.incoming_calls, "Incoming calls")
	end
	if client.supports_method(methods.callHierarchy_outgoingCalls) then
		k("grk", vim.lsp.buf.outgoing_calls, "Outgoing calls")
	end
end

-- Highlight all references to symbol under cursor
local function highlight_references(bufnr, client)
	local methods = vim.lsp.protocol.Methods

	if client.supports_method(methods.textDocument_documentHighlight) then
		vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
			callback = vim.lsp.buf.document_highlight,
			buffer = bufnr,
			group = augroup,
			desc = "Highlight references under the cursor",
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
			callback = vim.lsp.buf.clear_references,
			buffer = bufnr,
			group = augroup,
			desc = "Clear highlight references",
		})
	end
end

-- Set custom handlers for LSP methods
local function custom_handlers(client)
	for method, handler in pairs(lspconf.handlers) do
		if client.supports_method(method) then
			vim.lsp.handlers[method] = handler
		end
	end
end

-- Clear highlight references event handlers when detaching LSP client
local function clear_highlight_references(bufnr, client)
	local methods = vim.lsp.protocol.Methods

	if client.supports_method(methods.textDocument_documentHighlight) then
		vim.api.nvim_clear_autocmds({
			group = augroup,
			event = { "BufLeave", "CursorHold", "CursorMoved", "InsertEnter", "InsertLeave" },
			buffer = bufnr,
		})
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	pattern = "*",
	callback = function(event)
		local bufnr = event.buf
		local client = vim.fn.get_lsp_client(event.data.client_id)
		if not client then
			return
		end

		diagnostics()
		keymaps(bufnr, client)
		highlight_references(bufnr, client)
		custom_handlers(client)
	end,
})

vim.api.nvim_create_autocmd("LspDetach", {
	group = augroup,
	callback = function(event)
		local bufnr = event.buf
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		clear_highlight_references(bufnr, client)
	end,
})
