-- Highlight all references to symbol under cursor

local augroup = vim.api.nvim_create_augroup("ruicsh/custom/lsp-highlight-references", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_clients({ id = args.data.client_id })[1]
		if not client then
			return
		end

		local methods = vim.lsp.protocol.Methods
		if not client:supports_method(methods.textDocument_documentHighlight) then
			return
		end

		vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
			desc = "Highlight references under the cursor",
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
			desc = "Clear highlight references",
		})
	end,
})
