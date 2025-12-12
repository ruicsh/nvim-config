-- Disable semantic tokens for all LSP clients, TreeSitter is sufficient

local augroup = vim.api.nvim_create_augroup("ruicsh/custom/disable-semantic-tokens", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	pattern = "*",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		-- 'h vim.lsp.semantic_tokens.start()'
		client.server_capabilities.semanticTokensProvider = nil
	end,
})
