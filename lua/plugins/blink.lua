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
			preset = "default",
			["<c-n>"] = { "select_next", "show", "fallback" },
			["<c-p>"] = { "select_prev", "fallback" },
			["<c-y>"] = { "select_and_accept", "fallback" },
			["<cr>"] = { "select_and_accept", "fallback" },
			["<c-e>"] = { "hide", "fallback" },
			["<c-u>"] = { "scroll_documentation_up", "fallback" },
			["<c-d>"] = { "scroll_documentation_down", "fallback" },
		},
		signature = {
			enabled = true,
			window = {
				border = "rounded",
				max_height = 20,
				max_width = 50,
			},
		},
		sources = {
			default = { "lsp", "path" },
		},
	},

	event = { "InsertEnter", "CmdlineEnter" },
}
