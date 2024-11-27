--
-- Code writing
--

return {
	{ -- Formatter
		-- https://github.com/stevearc/conform.nvim
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
		config = function()
			-- Use conform for gq.
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			-- Start auto-formatting by default (and disable with my ToggleFormat command).
			vim.g.format_on_save = true
		end,

		event = { "BufWritePre" },
	},

	{ -- Autopairs
		-- https://github.com/windwp/nvim-autopairs
		"windwp/nvim-autopairs",
		opts = {
			check_ts = true,
		},

		event = { "InsertEnter" },
	},

	{ -- Autocomplete
		-- https://github.com/hrsh7th/nvim-cmp
		"hrsh7th/nvim-cmp",
		config = function()
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			-- copilot suggestions
			require("copilot_cmp").setup()
			lspkind.init({
				symbol_map = {
					Copilot = "",
				},
			})

			-- item's kind formatting
			local kind_formatter = lspkind.cmp_format({
				mode = "symbol",
				show_labelDetails = true,
				maxwidth = 50, -- Prevent the popup from showing more than provided characters.
				ellipsis_char = "...", -- When popup menu exceed maxwidth, the truncated part would show ellipsis_char instead.
				menu = {
					copilot = "[ghc]",
					buffer = "[buf]",
					nvim_lsp = "[lsp]",
					nvim_lua = "[api]",
					path = "[path]",
					luasnip = "[snip]",
				},
			})

			local cmp = require("cmp")
			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noselect",
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = kind_formatter,
					expandable_indicator = true,
				},
				mapping = {
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
					-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<cr>"] = cmp.mapping.confirm({ select = true }),
					["<tab>"] = cmp.mapping.confirm({ select = true }),
				},
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
		end,

		event = { "VeryLazy" },
		dependencies = {
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-buffer" },
			{ "zbirenbaum/copilot-cmp" },
			{ -- Pictograms for completion items (lspkind.nvim).
				-- https://github.com/onsails/lspkind.nvim
				"onsails/lspkind.nvim",
			},
			{ -- snippet engine (luasnip)
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
			{ -- GitHub Copilot (copilot.lua).
				-- https://github.com/zbirenbaum/copilot.lua
				"zbirenbaum/copilot.lua",
				opts = {
					suggestion = { enabled = false },
					panel = { enabled = false },
				},
			},
		},
	},

	{ -- Highlight matching words under cursor
		-- https://github.com/RRethy/vim-illuminate
		"rrethy/vim-illuminate",

		event = { "VeryLazy" },
	},
}
