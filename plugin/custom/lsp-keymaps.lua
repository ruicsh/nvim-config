-- LSP custom keymaps.

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/lsp-keymaps", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	pattern = "*",
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_clients({ id = args.data.client_id })[1]
		if not client then
			return
		end

		local k = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		local methods = vim.lsp.protocol.Methods

		-- Only set definition keymaps if the LSP server supports it
		if client:supports_method(methods.textDocument_definition) then
			local picker = require("snacks.picker")
			k("<cr>", picker.lsp_definitions, "Jump to definition")
			k("<c-w>]", "<c-w>o<c-w>v<c-]><c-w>L", "Jump to definition (vsplit)") -- `:h CTRL-]`
		end
	end,
})
