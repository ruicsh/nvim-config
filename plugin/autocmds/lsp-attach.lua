-- Autocmds for LSP attach/detach events

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/lsp-attach", { clear = true })

local DISABLE_FILETYPES = {
	"DiffviewFileHistory",
	"DiffviewFiles",
	"checkhealth",
	"diff",
	"fugitive",
	"git",
	"gitcommit",
	"help",
	"lazy",
	"lspinfo",
	"oil",
}

-- Jump to prev/next reference
local function jump_to_references(bufnr, client)
	local methods = vim.lsp.protocol.Methods

	local k = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	if client:supports_method(methods.textDocument_references) then
		-- Cache the current word and references list
		local current_word = nil
		local cache_items = nil

		local function find_ajdacent_reference(items, direction)
			if direction == "first" then
				return 1
			end

			if direction == "last" then
				return #items
			end

			-- Find the current reference based on cursor position
			local current_ref = 1
			local lnum = vim.fn.line(".")
			local col = vim.fn.col(".")
			for i, item in ipairs(items) do
				if item.lnum == lnum and item.col == col then
					current_ref = i
					break
				end
			end

			-- Calculate the adjacent reference based on direction
			local adjacent_ref = current_ref
			local delta = direction == "next" and 1 or -1
			adjacent_ref = math.min(#items, current_ref + delta)
			if adjacent_ref < 1 then
				adjacent_ref = 1
			end

			return adjacent_ref
		end

		local function jump_to_reference(direction)
			return function()
				-- Make sure we're at the beginning of the current word
				vim.cmd("normal! eb")

				-- If we are jumping on the same word, we can use the cached list
				if current_word == vim.fn.expand("<cword>") then
					local adjacent_ref = find_ajdacent_reference(cache_items, direction)
					vim.cmd("ll " .. adjacent_ref)
					return
				end

				vim.lsp.buf.references(nil, {
					on_list = function(options)
						-- Filter out references that are not in the current buffer
						local current_filename = vim.api.nvim_buf_get_name(0):lower()
						if vim.fn.has("win32") == 1 then
							current_filename = current_filename:gsub("/", "\\")
						end
						local items = vim.tbl_filter(function(item)
							return item.filename:lower() == current_filename
						end, options.items)

						-- No references found in the current buffer
						if #items == 0 then
							vim.notify("No references found", vim.log.levels.WARN)
							vim.fn.setloclist(0, {}, "r", { items = {} })
							current_word = nil
							cache_items = nil
							return
						end

						-- Cache the current word and items for later use
						current_word = vim.fn.expand("<cword>")
						cache_items = items

						-- Set the quickfix list and jump to the adjacent reference
						vim.fn.setloclist(0, {}, "r", { items = items })
						local adjacent_ref = find_ajdacent_reference(cache_items, direction)
						vim.cmd("ll " .. adjacent_ref)
					end,
				})
			end
		end

		k("[r", jump_to_reference("prev"), "Jump to previous reference")
		k("]r", jump_to_reference("next"), "Jump to next reference")
		k("[R", jump_to_reference("first"), "Jump to first reference")
		k("]R", jump_to_reference("last"), "Jump to last reference")
	end
end

-- Set keymaps for LSP
local function keymaps(bufnr, client)
	local k = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	-- See https://neovim.io/doc/user/lsp.html#lsp-defaults
	k("<cr>", vim.lsp.buf.definition, "Jump to definition")
	k("<c-w>]", "<c-w>o<c-w>v<c-]><c-w>L", "Jump to definition (vsplit)") -- `:h CTRL-]`

	-- Instead of using quickfix list, use snacks' LSP references picker
	local picker = require("snacks.picker")
	k("grr", picker.lsp_references, "References")
	k("gO", picker.lsp_symbols, "Symbols")
	k("<leader>dD", picker.diagnostics, "Diagnostics: Workspace")
	k("<leader>dd", picker.diagnostics_buffer, "Diagnostics: File")

	-- Jump to type implementation
	local methods = vim.lsp.protocol.Methods
	if client:supports_method(methods.textDocument_typeDefinition) then
		k("grt", vim.lsp.buf.type_definition, "Jump to type definition")
	end

	-- Jump to symbol references
	jump_to_references(bufnr, client)
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
	if not client:supports_method(methods.textDocument_documentHighlight) then
		return
	end

	vim.api.nvim_clear_autocmds({
		group = augroup,
		event = { "BufLeave", "CursorHold", "CursorMoved", "InsertEnter", "InsertLeave" },
		buffer = bufnr,
	})
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	pattern = "*",
	callback = function(event)
		local bufnr = event.buf
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		-- Skip certain filetypes
		local filetype = vim.bo[bufnr].filetype
		if vim.tbl_contains(DISABLE_FILETYPES, filetype) then
			return
		end

		keymaps(bufnr, client)
		highlight_references(bufnr, client)
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

vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd.edit(vim.lsp.log.get_filename())
end, { desc = "Open lsp.log file" })
