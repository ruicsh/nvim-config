-- Autocomplete
-- https://github.com/hrsh7th/nvim-cmp

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
				["<tab>"] = cmp.mapping(function(fallback)
					if has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s", "c" }),
				-- select item
				["<c-j>"] = cmp.mapping(function()
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				end, { "i", "s", "c" }),
				["<c-k>"] = cmp.mapping(function()
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
				end, { "i", "s", "c" }),
				-- confirm
				["<c-l>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = true })
					else
						fallback()
					end
				end, { "i", "s", "c" }),
				-- abort
				["<c-e>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.abort()
					else
						fallback()
					end
				end, { "i", "s", "c" }),
				-- scroll docs
				["<c-u>"] = cmp.mapping.scroll_docs(-4),
				["<c-d>"] = cmp.mapping.scroll_docs(4),
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp_signature_help", group_index = 0 },
				{ name = "nvim_lsp", group_index = 1 },
				{ name = "path", group_index = 2 },
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			selection_order = "near_cursor",
		})

		cmp.setup.cmdline({ "/", "?" }, {
			completion = {
				autocomplete = { cmp.TriggerEvent.TextChanged },
			},
			sources = {
				{ name = "buffer" },
			},
			selection_order = "near_cursor",
		})

		cmp.setup.cmdline(":", {
			completion = {
				autocomplete = { cmp.TriggerEvent.TextChanged },
			},
			sources = cmp.config.sources({
				{ name = "path" },
				{ name = "cmdline" },
			}),
			matching = {
				disallow_symbol_nonprefix_matching = false,
			},
			selection_order = "near_cursor",
		})
	end,

	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		{ "hrsh7th/nvim-cmp", event = { "BufRead" } },
		{ "hrsh7th/cmp-nvim-lsp", event = { "LspAttach" } },
		{ "hrsh7th/cmp-nvim-lsp-signature-help" },
		{ "hrsh7th/cmp-path", event = { "BufRead" } },
		{ "hrsh7th/cmp-buffer", event = { "BufRead" } },
		{ "hrsh7th/cmp-cmdline", event = { "CmdlineEnter" } },
	},
}
