-- Autocomplete
-- https://github.com/hrsh7th/nvim-cmp

local DISABLED_FILETYPES = {
	"DiffviewFileHistory",
	"DiffviewFiles",
	"checkhealth",
	"copilot-chat",
	"fugitive",
	"git",
	"gitcommit",
	"help",
	"lspinfo",
	"man",
	"neo-tree",
	"oil",
	"qf",
	"query",
	"scratch",
	"startuptime",
}

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
	"hrsh7th/nvim-cmp",
	config = function()
		local cmp = require("cmp")

		cmp.event:on("menu_opened", function()
			local copilot = require("copilot.suggestion")
			vim.b.copilot_suggestion_hidden = true
			copilot.dismiss()
		end)

		cmp.event:on("menu_closed", function()
			vim.b.copilot_suggestion_hidden = false
		end)

		cmp.setup({
			completion = {
				autocomplete = false,
				completeopt = "menu,menuone,noinsert",
			},
			mapping = {
				["<c-n>"] = cmp.mapping(function(fallback)
					if vim.tbl_contains(DISABLED_FILETYPES, vim.bo.filetype) then
						return fallback()
					end

					if cmp.visible() then
						cmp.select_next_item()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end),
				["<c-p>"] = cmp.mapping(function(fallback)
					if vim.tbl_contains(DISABLED_FILETYPES, vim.bo.filetype) then
						return fallback()
					end

					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end),
				["<cr>"] = cmp.mapping(function(fallback)
					if vim.tbl_contains(DISABLED_FILETYPES, vim.bo.filetype) then
						return fallback()
					end

					if cmp.visible() and cmp.get_active_entry() then
						cmp.confirm({ select = true })
					else
						fallback()
					end
				end),
				["<c-]>"] = cmp.mapping(function(fallback)
					if vim.tbl_contains(DISABLED_FILETYPES, vim.bo.filetype) then
						return fallback()
					end

					if cmp.visible() then
						cmp.abort()
					else
						fallback()
					end
				end),
				["<c-u>"] = cmp.mapping(function(fallback)
					if vim.tbl_contains(DISABLED_FILETYPES, vim.bo.filetype) then
						return fallback()
					end

					if cmp.visible() then
						cmp.scroll_docs(-4)
					else
						fallback()
					end
				end),
				["<c-d>"] = cmp.mapping(function(fallback)
					if vim.tbl_contains(DISABLED_FILETYPES, vim.bo.filetype) then
						return fallback()
					end

					if cmp.visible() then
						cmp.scroll_docs(4)
					else
						fallback()
					end
				end),
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp_signature_help", group_index = 0 },
				{ name = "nvim_lsp", group_index = 1 },
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
		})
	end,

	event = { "InsertEnter" },
	dependencies = {
		{ "hrsh7th/cmp-nvim-lsp", event = { "LspAttach" } },
		{ "hrsh7th/cmp-nvim-lsp-signature-help", event = { "LspAttach" } },
	},
}
