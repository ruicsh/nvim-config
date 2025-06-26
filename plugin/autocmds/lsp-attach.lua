-- Autocmds for LSP attach/detach events

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/lsp-attach", { clear = true })

local icons = require("config/icons")

-- Configure diagnostics
local function diagnostics()
	vim.diagnostic.config({
		float = {
			border = "single",
			width = 60,
		},
		jump = {
			float = true,
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
		virtual_text = {
			spacing = 4,
			source = "if_many",
			prefix = "●",
			severity = vim.diagnostic.severity.ERROR,
			current_line = true,
		},
	})
end

-- Set keymaps for LSP
local function keymaps(bufnr, client)
	local snacks = require("snacks")

	local k = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end
	local methods = vim.lsp.protocol.Methods

	-- Open definition in a new vertical window
	local function vsplit_and_definition()
		vim.ui.open_side_panel(false)
		vim.lsp.buf.definition()
	end

	local function hover()
		-- https://neovim.io/doc/user/lsp.html#vim.lsp.buf.hover.Opts
		vim.lsp.buf.hover({
			border = "single",
			focusable = false,
			close_events = { "CursorMoved", "InsertEnter", "FocusLost" },
		})
	end

	-- https://neovim.io/doc/user/lsp.html#lsp-defaults
	k("gd", vim.lsp.buf.definition, "Jump to definition")
	k("<cr>", vim.lsp.buf.definition, "Jump to definition")
	k("<c-]>", vim.lsp.buf.definition, "Jump to definition")
	k("<c-w>]", vsplit_and_definition, "Jump to definition (vsplit)") -- :h CTRL-w_]
	k("gD", vim.lsp.buf.declaration, "Jump to declaration")
	k("grr", snacks.picker.lsp_references, "References")
	k("gO", snacks.picker.lsp_symbols, "Symbols")
	k("<leader>xx", snacks.picker.diagnostics, "Diagnostics: Workspace")
	k("<leader>xf", snacks.picker.diagnostics_buffer, "Diagnostics: File")
	k("K", hover, "Hover")

	if client:supports_method(methods.textDocument_typeDefinition) then
		k("grt", vim.lsp.buf.type_definition, "Jump to type definition")
	end
end

-- Highlight all references to symbol under cursor
local function highlight_references(bufnr, client)
	local methods = vim.lsp.protocol.Methods

	if not client:supports_method(methods.textDocument_documentHighlight) then
		return
	end

	vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
		buffer = bufnr,
		group = augroup,
		callback = vim.lsp.buf.document_highlight,
		desc = "Highlight references under the cursor",
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
		buffer = bufnr,
		group = augroup,
		callback = vim.lsp.buf.clear_references,
		desc = "Clear highlight references",
	})
end

-- Clear highlight references event handlers
local function clear_highlight_references(bufnr, client)
	local methods = vim.lsp.protocol.Methods

	if client:supports_method(methods.textDocument_documentHighlight) then
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
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		-- Skip oil buffers
		if vim.bo[bufnr].filetype == "oil" then
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

vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd.edit(vim.lsp.log.get_filename())
end, { desc = "Open lsp.log file" })
