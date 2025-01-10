-- Autocomplete
-- https://github.com/hrsh7th/nvim-cmp

return {
	"hrsh7th/nvim-cmp",
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		-- copilot suggestions
		require("copilot_cmp").setup()
		lspkind.init({
			symbol_map = {
				Copilot = "",
			},
		})

		cmp.setup({
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, item)
					item = lspkind.cmp_format({
						mode = "symbol",
						show_labelDetails = true,
						maxwidth = 50,
						ellipsis_char = "...",
						menu = {
							copilot = "[ghc]",
							buffer = "[buf]",
							nvim_lsp = "[lsp]",
							nvim_lua = "[api]",
							path = "[path]",
							luasnip = "[snip]",
						},
					})(entry, item)

					return item
				end,
				expandable_indicator = true,
			},

			mapping = cmp.mapping.preset.insert({
				["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-y>"] = cmp.mapping(
					cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
					{ "i", "c" }
				),
				["<c-e>"] = cmp.mapping.abort(),
				["<cr>"] = cmp.mapping.confirm({ select = false }),
				["<tab>"] = cmp.mapping.confirm({ select = true }),
			}),
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			sources = cmp.config.sources({
				{ name = "lazydev", group_index = 0 },
				{ name = "copilot" },
				{ name = "nvim_lsp" },
				{ name = "path" },
				{ name = "buffer" },
				{
					name = "luasnip",
					option = {
						use_show_condition = false,
						show_autosnippets = true,
					},
				},
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline({
				["<down>"] = {
					c = function()
						cmp.select_next_item()
					end,
				},
				["<up>"] = {
					c = function()
						cmp.select_prev_item()
					end,
				},
			}),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline({
				["<down>"] = {
					c = function()
						cmp.select_next_item()
					end,
				},
				["<up>"] = {
					c = function()
						cmp.select_prev_item()
					end,
				},
			}),
			sources = cmp.config.sources({
				{ name = "path" },
				{ name = "cmdline" },
			}),
			matching = {
				disallow_symbol_nonprefix_matching = false,
			},
		})
	end,

	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-cmdline" },
		{ "zbirenbaum/copilot-cmp" },
		{ -- Pictograms for completion items
			-- https://github.com/onsails/lspkind.nvim
			"onsails/lspkind.nvim",
		},
		{ -- Snippet engine
			-- https://github.com/L3MON4D3/LuaSnip
			"L3MON4D3/LuaSnip",
			config = function()
				require("luasnip/loaders/from_vscode").lazy_load()
			end,
			build = "make install_jsregexp",
			dependencies = {
				"saadparwaiz1/cmp_luasnip",
				"rafamadriz/friendly-snippets",
			},
		},
		{ -- GitHub Copilot
			-- https://github.com/zbirenbaum/copilot.lua
			"zbirenbaum/copilot.lua",
			opts = {
				suggestion = { enabled = false },
				panel = { enabled = false },
			},
		},
	},
}
