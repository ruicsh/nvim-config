-- Highlight all TailwindCSS colors

local augroup = vim.api.nvim_create_augroup("ruicsh/custom/lsp-tailwindcss-colors", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_clients({ id = args.data.client_id })[1]
		if not client or client.name ~= "tailwindcss" then
			return
		end

		-- Skip fugitive diff buffers (e.g. from :Gdiff) since they're
		-- transient and the plugin can't attach to them reliably
		if vim.bo[bufnr].buftype ~= "" then
			return
		end

		if vim.api.nvim_buf_get_name(bufnr):match("^fugitive://") then
			return
		end

		if vim.lsp.buf_is_attached(bufnr, client.id) then
			require("tailwindcss-colors").buf_attach(bufnr)
		end
	end,
})
