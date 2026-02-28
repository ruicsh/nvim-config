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

		require("tailwindcss-colors").buf_attach(client, bufnr)
	end,
})
