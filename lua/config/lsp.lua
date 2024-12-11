local M = {}

M = {
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
	servers = {
		["angularls@18.2.0"] = {
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
