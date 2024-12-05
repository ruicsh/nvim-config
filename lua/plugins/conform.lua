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
			scss = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			vue = { "prettier" },
		},
		format_on_save = function()
			-- Stop if we disabled formatting on save.
			if not vim.g.format_on_save then
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
		-- Start auto-formatting by default (and disable with my ToggleFormat command).
		vim.g.format_on_save = true
	end,

	event = { "BufWritePre" },
}
