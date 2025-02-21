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
				["<c-n>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s", "c" }),
				["<c-p>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { "i", "s", "c" }),
				["<c-l>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = true })
					else
						fallback()
					end
				end, { "i", "s", "c" }),
				["<c-]>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.abort()
					else
						fallback()
					end
				end, { "i", "s", "c" }),
				["<c-u>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.scroll_docs(-4)
					else
						fallback()
					end
				end, { "i", "c", "s" }),
				["<c-d>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.scroll_docs(4)
					else
						fallback()
					end
				end, { "i", "c", "s" }),
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

		local cmdline_options = {
			completion = {
				autocomplete = { cmp.TriggerEvent.TextChanged },
			},
			formatting = {
				format = function(_, vim_item)
					vim_item.kind = ""
					return vim_item
				end,
			},
			selection_order = "near_cursor",
		}

		cmp.setup.cmdline(
			{ "/", "?" },
			vim.tbl_extend("force", cmdline_options, {
				sources = {
					{ name = "buffer" },
				},
			})
		)

		cmp.setup.cmdline(
			":",
			vim.tbl_extend("force", cmdline_options, {
				sources = {
					{ name = "path" },
					{ name = "cmdline" },
				},
			})
		)
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
