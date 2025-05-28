-- Formatter
-- https://github.com/stevearc/conform.nvim

return {
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
		formatters_by_ft = {
			css = { "prettier" },
			html = { "prettier" },
			htmlangular = { "prettier" },
			javascript = { "prettier" },
			json = { "prettier" },
			lua = { "stylua" },
			markdown = { "prettierd" },
			python = { "black" },
			rust = { "rustfmt" },
			scss = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			vue = { "prettier" },
		},
		format_on_save = function()
			-- Stop if we disabled formatting on save.
			if vim.fn.env_get("FORMAT_ON_SAVE") == "false" then
				return nil
			end

			return {
				timeout_ms = 2500,
				lsp_format = "fallback",
			}
		end,
	},
	init = function()
		-- Use conform for gq.
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,

	event = { "BufWritePre" },
	enabled = not vim.g.vscode,
}
