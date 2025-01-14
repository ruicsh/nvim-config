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
				Copilot = "",
			},
		})

		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

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
							buffer = "[buf]",
							cmdline = "[cmd]",
							cmdline_history = "[hst]",
							copilot = "[cop]",
							nvim_lsp = "[lsp]",
							nvim_lsp_signature_help = "[sig]",
							nvim_lua = "[lua]",
							path = "[pat]",
						},
					})(entry, item)

					return item
				end,
				expandable_indicator = true,
			},

			mapping = {
				["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-u>"] = cmp.mapping.scroll_docs(-4), -- scroll up preview
				["<c-d>"] = cmp.mapping.scroll_docs(4), -- scroll down preview
				["<c-e>"] = cmp.mapping.abort(), -- close menu, and don't pick anything
				["<esc>"] = cmp.mapping.abort(),
				["<c-]>"] = cmp.mapping.abort(),

				-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
				["<cr>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						if cmp.get_active_entry() then
							-- suggestion was selected, use it
							cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
						else
							-- make it go away if hit <cr> with nothing selected
							cmp.abort()
						end
					else
						fallback()
					end
				end),
				["<tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						local entries = cmp.get_entries()
						-- there's only 1 suggestion
						if #entries == 1 then
							-- and it's from copilot
							if entries[1].source.name == "copilot" then
								local active = cmp.get_active_entry()
								-- it's not selected yet, select and preview it
								if not active then
									cmp.select_next_item()
								else
									-- it's already previewed, I don't want it, hit <tab> again
									cmp.abort()
								end
							else
								-- if there is only, but not from copilot, select it
								cmp.confirm({ select = true })
							end
						else
							cmp.select_next_item()
						end
					elseif has_words_before() then
						cmp.complete()
						-- if there is only, select it
						if #cmp.get_entries() == 1 then
							cmp.confirm({ select = true })
						end
					else
						fallback()
					end
				end, { "i", "s" }),
				["<s-tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { "i", "s" }),
			},

			sources = cmp.config.sources({
				{ name = "nvim_lsp_signature_help", group_index = 0 },
				{ name = "nvim_lsp" },
				{ name = "copilot" },
				{ name = "path" },
				{ name = "buffer" },
			}),

			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			selection_order = "near_cursor",
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
				{ name = "cmdline_history", max_item_count = 5 },
				{ name = "buffer" },
			},
			selection_order = "near_cursor",
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
				{ name = "cmdline_history", max_item_count = 5 },
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
		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-nvim-lsp-signature-help" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-cmdline" },
		{ "zbirenbaum/copilot-cmp" },
		{ "dmitmel/cmp-cmdline-history" },
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
		},
	},
}
