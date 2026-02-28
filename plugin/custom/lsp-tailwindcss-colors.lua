-- Highlight all TailwindCSS colors

local augroup = vim.api.nvim_create_augroup("ruicsh/custom/lsp-tailwindcss-colors", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	pattern = "*",
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client or client.name ~= "tailwindcss" then
			return
		end

		require("tailwindcss-colors").buf_attach(client, bufnr)
	end,
})
