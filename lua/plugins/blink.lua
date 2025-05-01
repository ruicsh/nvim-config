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
	version = "1.*",

	opts = {
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 100,
				window = {
					border = "single",
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
				border = "single",
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
			["<c-n>"] = { "select_next", "show", "fallback" },
			["<c-j>"] = { "select_next", "show", "fallback" },
			["<c-k>"] = { "select_prev", "show", "fallback" },
		},
		snippets = { preset = "mini_snippets" },
		signature = {
			enabled = true,
			window = {
				border = "rounded",
				max_height = 20,
				max_width = 50,
			},
		},
		sources = {
			default = { "snippets", "buffer", "lsp", "path" },
		},
	},

	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = { "echasnovski/mini.snippets" },
}
