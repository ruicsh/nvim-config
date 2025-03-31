-- Autocmds for LSP attach/detach events

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/lsp-attach", { clear = true })

local icons = require("config/icons")

-- Configure diagnostics
local function diagnostics()
	vim.diagnostic.config({
		heverity_sort = true,
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
		virtual_text = {
			spacing = 4,
			source = "if_many",
			prefix = "●",
			severity = vim.diagnostic.severity.ERROR,
		},
	})

	-- Toggle diagnostics on current line
	vim.keymap.set("n", "<c-w>d", function()
		vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false })

		-- Toggle diagnostics off all lines when cursor moves
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = vim.api.nvim_create_augroup("line-diagnostics", { clear = true }),
			callback = function()
				vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
				return true
			end,
		})
	end, { desc = "Toggle diagnostics on current line" })
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

	if client.supports_method(methods.textDocument_typeDefinition) then
		k("grt", vim.lsp.buf.type_definition, "Jump to type definition")
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

-- Clear highlight references event handlers
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
		if vim.g.vscode then
			return
		end

		local bufnr = event.buf
		local client = vim.fn.get_lsp_client(event.data.client_id)
		if not client then
			return
		end

		diagnostics()
		keymaps(bufnr, client)
		highlight_references(bufnr, client)
	end,
})

vim.api.nvim_create_autocmd("LspDetach", {
	group = augroup,
	callback = function(event)
		if vim.g.vscode then
			return
		end

		local bufnr = event.buf
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		clear_highlight_references(bufnr, client)
	end,
})
