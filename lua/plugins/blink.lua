-- Autocomplete
-- https://cmp.saghen.dev

local DISABLED_FILETYPES = {
	"checkhealth",
	"copilot-chat",
	"fugitive",
	"git",
	"gitcommit",
	"help",
	"lspinfo",
	"man",
	"qf",
	"query",
	"scratch",
	"startuptime",
}

local DISABLED_BUFTYPES = {
	"nofile",
	"nowrite",
	"prompt",
}

return {
	"saghen/blink.cmp",

	opts = {
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 100,
				window = {
					max_height = 20,
					max_width = 50,
				},
			},
			list = {
				selection = {
					auto_insert = true,
				},
			},
			menu = {
				auto_show = true,
				draw = {
					columns = {
						{ "kind_icon" },
						{ "label" },
					},
					treesitter = { "lsp" },
				},
			},
		},
		enabled = function()
			return not (
				vim.tbl_contains(DISABLED_BUFTYPES, vim.bo.buftype)
				or vim.tbl_contains(DISABLED_FILETYPES, vim.bo.filetype)
			)
		end,
		fuzzy = {
			implementation = "prefer_rust_with_warning",
			sorts = { "exact", "score", "sort_text" },
		},
		keymap = {
			preset = "super-tab",
			["<c-e>"] = { "hide", "show" }, -- Toggle completion menu
			["<c-n>"] = { "select_next", "show", "fallback" },
			["<c-j>"] = { "select_next", "show", "fallback" },
			["<c-k>"] = { "select_prev", "show", "fallback" },
		},
		signature = {
			enabled = true,
			window = {
				max_height = 20,
				max_width = 50,
			},
		},
		sources = {
			default = { "path", "buffer", "lsp" },
		},
	},

	event = { "InsertEnter", "CmdlineEnter" },
	enabled = not vim.g.vscode,
	version = "1.*",
}
