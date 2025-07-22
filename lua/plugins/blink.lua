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
	"oil",
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
						{ "label" },
						{ "kind" },
					},
					treesitter = { "lsp" },
				},
			},
			trigger = {
				show_on_blocked_trigger_characters = {
					" ",
					"\n",
					"\t",
					"(",
					")",
					"{",
					"}",
					"[",
					"]",
					",",
					":",
					";",
					"=",
					"+",
					"-",
					"*",
					"/",
					"%",
					"&",
					"|",
					"^",
					"~",
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
			implementation = vim.fn.env_get("BLINK_FUZZY_IMPLEMENTATION") or "prefer_rust_with_warning",
			sorts = { "exact", "score", "sort_text" },
		},
		keymap = {
			["tab"] = { "select_next", "fallback" },
			["<s-tab>"] = { "select_prev", "fallback" },
			["<cr>"] = { "select_and_accept", "fallback" },
			["<c-e>"] = { "hide", "show", "fallback" },
			["<c-n>"] = { "select_next", "show", "fallback" },
			["<c-p>"] = { "select_prev", "show", "fallback" },
			["<c-j>"] = { "select_next", "show", "fallback" },
			["<c-k>"] = { "select_prev", "show", "fallback" },
		},
		signature = {
			enabled = true,
			window = {
				border = "single",
				max_height = 20,
				max_width = 50,
			},
		},
		sources = {
			default = { "path", "buffer", "snippets", "lsp" },
		},
	},

	event = { "InsertEnter", "CmdlineEnter" },
	version = "1.*",
}
