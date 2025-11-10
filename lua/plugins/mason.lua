-- Install LSP servers and 3rd-party tools
-- https://github.com/mason-org/mason.nvim

-- https://mason-registry.dev/registry/list
local PACKAGES = {
	-- LSP
	"angular-language-server",
	"ansible-language-server",
	"css-lsp",
	"cssmodules-language-server",
	"css-variables-language-server",
	"dockerfile-language-server",
	"harper-ls",
	"html-lsp",
	"json-lsp",
	"lua-language-server",
	"pyright",
	"typescript-language-server",
	"yaml-language-server",
	-- Format
	"black",
	"flake8",
	"prettierd",
	"stylua",
	-- Lint
	"eslint-lsp",
	"pylint",
}

return {
	{
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
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		enabled = not os.getenv("NVIM_GIT_DIFF"),
		opts = function()
			-- Filter out disabled packages
			local disabled = vim.fn.env_get_list("MASON_DISABLED_PACKAGES")
			local packages = {}
			for _, package in ipairs(PACKAGES) do
				if not vim.tbl_contains(disabled, package) then
					table.insert(packages, package)
				end
			end

			return {
				ensure_installed = packages,
				integrations = {
					["mason-lspconfig"] = false,
					["mason-null-ls"] = false,
					["mason-nvim-dap"] = false,
				},
			}
		end,

		dependencies = {
			"mason-org/mason.nvim",
		},
	},
}
