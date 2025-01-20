-- Autocomplete
-- https://github.com/hrsh7th/nvim-cmp

local function setup_ghost_text()
	local config = require("cmp.config")

	-- Only show ghost text at word boundaries, not inside keywords.
	-- https://github.com/wincent/wincent/blob/main/aspects/nvim/files/.config/nvim/after/plugin/nvim-cmp.lua
	local toggle_ghost_text = function()
		if vim.api.nvim_get_mode().mode ~= "i" then
			return
		end

		local cursor_column = vim.fn.col(".")
		local current_line_contents = vim.fn.getline(".")
		local character_after_cursor = current_line_contents:sub(cursor_column, cursor_column)

		local should_enable_ghost_text = character_after_cursor == ""
			or vim.fn.match(character_after_cursor, [[\k]]) == -1

		local current = config.get().experimental.ghost_text
		if current ~= should_enable_ghost_text then
			config.set_global({
				experimental = {
					ghost_text = should_enable_ghost_text,
				},
			})
		end
	end

	vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMovedI" }, {
		callback = toggle_ghost_text,
	})
end

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

		-- Only show ghost text at word boundaries, not inside keywords.
		setup_ghost_text()

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
				["<c-l>"] = cmp.mapping(function(fallback)
					-- Until https://github.com/hrsh7th/nvim-cmp/issues/1716
					-- (cmp.ConfirmBehavior.MatchSuffix) gets implemented, use this local wrapper
					if cmp.visible() then
						local entry = cmp.get_selected_entry()
						local behavior = cmp.ConfirmBehavior.Replace

						if entry then
							local completion_item = entry.completion_item
							local newText = ""
							-- lsp server completion
							if completion_item.textEdit then
								newText = completion_item.textEdit.newText
							elseif
								type(completion_item.insertText) == "string" and completion_item.insertText ~= ""
							then
								newText = completion_item.insertText
							else
								newText = completion_item.word or completion_item.label or ""
							end

							-- How many characters will be different after the cursor position if we replace?
							local diff_after = math.max(0, entry.replace_range["end"].character + 1)
								- entry.context.cursor.col

							-- Does the text that will be replaced after the cursor match the suffix
							-- of the `newText` to be inserted? If not, we should `Insert` instead.
							if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
								behavior = cmp.ConfirmBehavior.Insert
							end
						end

						cmp.confirm({ select = true, behavior = behavior })
					else
						fallback()
					end
				end, { "i", "s" }),

				-- move up/down the menu
				["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<c-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
				["<c-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
				["<up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

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

			experimental = {
				-- see also `setup_ghost_text()` above.
				ghost_text = true,
			},
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
