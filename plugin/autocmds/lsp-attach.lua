-- LSP attach.

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/lsp_attach", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(args)
		local function k(lhs, rhs, opts)
			local options = vim.tbl_extend("force", { buffer = args.buf }, opts or {})
			options.desc = "LSP: " .. opts.desc
			vim.keymap.set("n", lhs, rhs, options)
		end

		local client = vim.lsp.get_client_by_id(args.data.client_id)

		-- Only set definition keymaps if the LSP server supports it
		if client:supports_method("textDocument/definition") then
			local picker = require("snacks.picker")
			k("<cr>", picker.lsp_definitions, { desc = "Jump to definition" })
			k("<c-w>]", "<c-w>o<c-w>v<c-]><c-w>L", { desc = "Jump to definition (vsplit)" }) -- `:h CTRL-]`
		end
	end,
})
