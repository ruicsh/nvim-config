-- LSP config
-- https://github.com/neovim/nvim-lspconfig

local lspconf = require("config/lsp")

return {
	"neovim/nvim-lspconfig",
	config = function()
		-- LSP servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		require("mason").setup()

		require("mason-tool-installer").setup({
			run_on_start = true,
			ensure_installed = vim.tbl_keys(lspconf.tools or {}),
		})

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
	dependencies = {
		{ -- Install LSP servers
			-- https://github.com/williamboman/mason.nvim
			"williamboman/mason.nvim",
		},
		{ -- Install and upgrade 3rd party tools
			-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		{ -- Easier to use lspconfig with mason
			-- https://github.com/williamboman/mason-lspconfig.nvim
			"williamboman/mason-lspconfig.nvim",
		},
		{ -- Pictograms for completion items (lspkind.nvim).
			-- https://github.com/onsails/lspkind.nvim
			"onsails/lspkind.nvim",
		},
	},
}
