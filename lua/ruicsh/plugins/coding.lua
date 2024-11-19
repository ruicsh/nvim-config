--
-- Code writing
--

return {
	{ -- Formatter (conform.nvim).
		-- https://github.com/stevearc/conform.nvim
		"stevearc/conform.nvim",
		keys = {
			{
				"<leader>=",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
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
	},

	{ -- Autopairs (nvim-autopairs).
		-- https://github.com/windwp/nvim-autopairs
		"windwp/nvim-autopairs",
		opts = {
			check_ts = true,
		},

		event = { "InsertEnter" },
	},

	{ -- Autocomplete (nvim-cmp).
		-- https://github.com/hrsh7th/nvim-cmp
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<c-b>"] = cmp.mapping.scroll_docs(-4),
					["<c-f>"] = cmp.mapping.scroll_docs(4),
					["<c-space>"] = cmp.mapping.complete({ mode = cmp.TriggerEvent.Insert }),
					["<c-y>"] = cmp.mapping.confirm({ select = true }),
					["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<c-e>"] = cmp.mapping.abort(),
					-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<cr>"] = cmp.mapping.confirm({ select = true }),
				}),
				preselect = "item",
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "path" },
				}),
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = require("lspkind").cmp_format({
						mode = "symbol", -- Show only symbol annotations.
						maxwidth = 50, -- Prevent the popup from showing more than provided characters.
						ellipsis_char = "...", -- When popup menu exceed maxwidth, the truncated part would show ellipsis_char instead.
					}),
					expandable_indicator = true,
				},
			})
		end,

		event = { "VeryLazy" },
		dependencies = {
			{ "hrsh7th/nvim-cmp", event = { "InsertEnter" } },
			{ "hrsh7th/cmp-nvim-lsp", event = { "InsertEnter" } },
			{ "hrsh7th/cmp-path", event = { "InsertEnter" } },
			{ "onsails/lspkind.nvim" },
		},
	},

	{ -- Highlight matching words under cursor (vim-illuminate).
		-- https://github.com/RRethy/vim-illuminate
		"rrethy/vim-illuminate",
	},

	{ -- GitHub Copilot (copilot.lua).
		-- https://github.com/zbirenbaum/copilot.lua
		"zbirenbaum/copilot.lua",
		opts = {
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<tab>",
					next = "<c-j>",
				},
			},
		},

		cmd = "Copilot",
	},
}
