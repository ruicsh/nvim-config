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
		local picker = require("snacks.picker")

		-- Only set definition keymaps if the LSP server supports it
		if client:supports_method("textDocument/definition") then
			k("<cr>", picker.lsp_definitions, { desc = "Jump to definition" })
			k("<c-w>]", "<c-w>o<c-w>v<c-]><c-w>L", { desc = "Jump to definition (vsplit)" }) -- `:h CTRL-]`
		end

		-- Override default LSP keymaps with snacks.picker variants
		k("gO", picker.lsp_symbols, { desc = "Symbols" })
		k("grr", picker.lsp_references, { desc = "References" })
		k("grI", picker.lsp_incoming_calls, { desc = "Incoming Calls" })
		k("grO", picker.lsp_outgoing_calls, { desc = "Outgoing Calls" })

		-- Instead of using quickfix list, use snacks.picker
		k("<leader>dD", picker.diagnostics, { desc = "Diagnostics (workspace)" })
		k("<leader>dd", picker.diagnostics_buffer, { desc = "Diagnostics (file)" })
	end,
})
