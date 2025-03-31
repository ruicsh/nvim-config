-- Install LSP servers
-- https://github.com/williamboman/mason.nvim

local lspconf = require("config/lsp")

return {
	"williamboman/mason.nvim",
	config = function()
		require("mason").setup()

		require("mason-tool-installer").setup({
			run_on_start = true,
			ensure_installed = vim.tbl_keys(lspconf.tools or {}),
		})

		-- LSP servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(lspconf.servers or {}),
			handlers = {
				function(server_name)
					-- Don't setup ts_ls, we're using tsserver from typescript-tools
					if server_name == "ts_ls" then
						return
					end

					local server = lspconf.servers[server_name] or {}

					local conf = vim.tbl_deep_extend("force", server, {
						capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {}),
					})

					require("lspconfig")[server_name].setup(conf)
				end,
			},
		})
	end,

	event = { "BufReadPre", "BufNewFile" },
	enabled = not vim.g.vscode,
	dependencies = {
		{ -- Quickstart configs for Nvim LSP
			-- https://github.com/neovim/nvim-lspconfig
			"neovim/nvim-lspconfig",
		},
		{ -- Install and upgrade 3rd party tools
			-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		{ -- Easier to use lspconfig with mason
			-- https://github.com/williamboman/mason-lspconfig.nvim
			"williamboman/mason-lspconfig.nvim",
		},
	},
}
