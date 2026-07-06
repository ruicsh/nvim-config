-- Disable semantic tokens for all LSP clients, TreeSitter is sufficient

local augroup = vim.api.nvim_create_augroup("ruicsh/custom/disable-semantic-tokens", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(args)
		if vim.api.nvim_buf_get_name(args.buf):match("^fugitive://") then
			return
		end

		local client = vim.lsp.get_clients({ id = args.data.client_id })[1]
		if not client then
			return
		end

		-- 'h vim.lsp.semantic_tokens.start()'
		client.server_capabilities.semanticTokensProvider = nil
	end,
})
