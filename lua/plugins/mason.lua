local T = require("lib")

-- https://mason-registry.dev/registry/list
local PACKAGES = {
	-- LSP
	"angularls",
	"ansiblels",
	"css_variables",
	"cssls",
	"cssmodules_ls",
	"dockerls",
	"eslint",
	"harper_ls",
	"html",
	"jsonls",
	"lua_ls",
	"pyright",
	"tailwindcss",
	"ts_ls",
	"yamlls",
	-- Format
	"black",
	"flake8",
	"prettierd",
	"stylua",
	-- Lint
	"pylint",
}

return {
	{
		-- Install LSP servers and 3rd-party tools
		-- https://github.com/mason-org/mason.nvim
		"mason-org/mason.nvim",
		enabled = not os.getenv("NVIM_GIT_DIFF"),
		init = function()
			-- Do not crowd home directory with NPM cache folder
			vim.env.npm_config_cache = vim.env.HOME .. "/.cache/npm"
		end,
		opts = {
			ui = {
				border = "rounded",
				height = 0.85,
				width = 0.8,
			},
		},

		event = { "VeryLazy" },
	},
	{
		-- Bridge between mason.nvim and lspconfig
		-- https://github.com/mason-org/mason-lspconfig.nvim
		"mason-org/mason-lspconfig.nvim",
		enabled = not os.getenv("NVIM_GIT_DIFF"),
		opts = {},

		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
	{
		-- Install and upgrade 3rd-party tools managed by mason.nvim
		-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		enabled = not os.getenv("NVIM_GIT_DIFF"),
		opts = function()
			local packages = vim.tbl_deep_extend("force", {}, PACKAGES)

			local disabled_packages = T.env.get_list("MASON_DISABLED_PACKAGES")
			local disabled_servers = T.env.get_list("LSP_DISABLED_SERVERS")
			local disabled = vim.list_extend(vim.list_slice(disabled_packages), disabled_servers)

			-- Filter out disabled packages and servers
			packages = vim.tbl_filter(function(pkg)
				return not vim.tbl_contains(disabled, pkg)
			end, packages)

			return {
				ensure_installed = packages,
				integrations = {
					["mason-lspconfig"] = true,
					["mason-null-ls"] = false,
					["mason-nvim-dap"] = false,
				},
			}
		end,

		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
	},
}
