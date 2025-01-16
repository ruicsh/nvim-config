-- Autocomplete
-- https://github.com/hrsh7th/nvim-cmp

return {
	"hrsh7th/nvim-cmp",
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")

		-- copilot suggestions
		require("copilot_cmp").setup()
		lspkind.init({
			symbol_map = {
				Snippet = "",
				Copilot = "",
			},
		})

		cmp.setup({
			completion = { completeopt = "menu,menuone,noinsert" },

			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, item)
					item = lspkind.cmp_format({
						mode = "symbol",
						show_labelDetails = true,
						maxwidth = 50,
						ellipsis_char = "...",
						menu = {
							buffer = "[buf]",
							cmdline = "[cmd]",
							cmdline_history = "[hst]",
							copilot = "[cop]",
							nvim_lsp = "[lsp]",
							nvim_lsp_signature_help = "[sig]",
							nvim_lua = "[lua]",
							path = "[pat]",
							snippets = "[snp]",
						},
					})(entry, item)

					return item
				end,
				expandable_indicator = true,
			},

			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			},

			mapping = {
				-- confirm completion
				["<c-m>"] = cmp.mapping.confirm({ select = true }),

				-- move up/down the menu
				["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

				-- scroll up/down
				["<c-u>"] = cmp.mapping.scroll_docs(-4),
				["<c-d>"] = cmp.mapping.scroll_docs(4),

				-- close menu, and don't pick anything
				["<c-]>"] = cmp.mapping.abort(),
			},

			sources = cmp.config.sources({
				{ name = "nvim_lsp_signature_help", group_index = 0 },
				{ name = "snippets", group_index = 1 },
				{ name = "copilot", group_index = 2 },
				{ name = "path", group_index = 3 },
				{ name = "buffer", group_index = 4 },
				{ name = "nvim_lsp", group_index = 5 },
			}),

			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			selection_order = "near_cursor",
		})

		cmp.setup.cmdline({ "/", "?" }, {
			autocomplete = { cmp.TriggerEvent.TextChanged },
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
			selection_order = "near_cursor",
		})

		cmp.setup.cmdline(":", {
			autocomplete = { cmp.TriggerEvent.TextChanged },
			mapping = cmp.mapping.preset.cmdline(),
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
		{ "zbirenbaum/copilot-cmp", event = { "BufRead" } },
		{ -- Pictograms for completion items
			-- https://github.com/onsails/lspkind.nvim
			"onsails/lspkind.nvim",
		},
		{ -- GitHub Copilot
			-- https://github.com/zbirenbaum/copilot.lua
			"zbirenbaum/copilot.lua",
			opts = {
				suggestion = { enabled = false },
				panel = { enabled = false },
			},
			event = { "BufRead" },
		},
	},
}
