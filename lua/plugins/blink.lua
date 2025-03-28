-- Autocomplete
-- https://cmp.saghen.dev

local DISABLED_FILETYPES = {
	"DiffviewFileHistory",
	"DiffviewFiles",
	"checkhealth",
	"copilot-chat",
	"fugitive",
	"git",
	"gitcommit",
	"help",
	"lspinfo",
	"man",
	"neo-tree",
	"oil",
	"qf",
	"query",
	"scratch",
	"startuptime",
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
					auto_insert = false,
				},
			},
			menu = {
				auto_show = false,
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
			local buftype = vim.bo.buftype
			local filetype = vim.bo.filetype
			return not (
				buftype == "nofile"
				or buftype == "nowrite"
				or buftype == "prompt"
				or vim.tbl_contains(DISABLED_FILETYPES, filetype)
			)
		end,
		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
		keymap = {
			preset = "default",
			["<c-n>"] = {
				function()
					local copilot = require("copilot.suggestion")
					vim.b.copilot_suggestion_hidden = true
					copilot.dismiss()
				end,
				"select_next",
				"show",
				"fallback",
			},
			["<c-p>"] = { "select_prev", "fallback" },
			["<c-y>"] = {
				function()
					vim.b.copilot_suggestion_hidden = false
				end,
				"select_and_accept",
				"fallback",
			},
			["<c-e>"] = {
				function()
					vim.b.copilot_suggestion_hidden = false
				end,
				"hide",
				"fallback",
			},
			["<c-u>"] = { "scroll_documentation_up", "fallback" },
			["<c-d>"] = { "scroll_documentation_down", "fallback" },
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
			default = { "lsp", "path" },
		},
	},

	event = { "InsertEnter", "CmdlineEnter" },
}
