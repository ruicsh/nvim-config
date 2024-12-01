local M = {}

M.icons = {
	dap = {
		Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
		Breakpoint = " ",
		BreakpointCondition = " ",
		BreakpointRejected = { " ", "DiagnosticError" },
		LogPoint = ".>",
	},
	diagnostics = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	},
	git = {
		added = " ",
		modified = " ",
		removed = " ",
		Add = "┃",
		Change = "┋",
		Delete = "",
		TopDelete = "",
		ChangeDelete = "┃",
		Untracked = "┃",
	},
}

M.lsp = {
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
	servers = {
		angularls = {
			filetypes = { "htmlangular", "typescript" },
		},
		cssls = {},
		cssmodules_ls = {},
		eslint = {},
		html = {},
		jsonls = {},
		lua_ls = {
			settings = {
				Lua = {
					diagnostics = {
						disable = { "missing-parameters", "missing-fields" },
					},
				},
			},
		},
		vuels = {},
	},
	tools = {
		prettierd = {},
		stylua = {},
	},
}

return M
