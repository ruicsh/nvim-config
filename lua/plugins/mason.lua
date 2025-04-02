-- Install LSP servers
-- https://github.com/williamboman/mason.nvim

local LSP_SERVERS = {
	"angularls@18.2.0",
	"cssls",
	"cssmodules_ls",
	"eslint",
	"html",
	"jsonls",
	"lua_ls",
	"pyright",
	"rust_analyzer",
	"ts_ls",
}

local TOOLS = {
	"black",
	"codelldb",
	"flake8",
	"prettierd",
	"pylint",
	"stylua",
}

-- LSP config
local function setup_lsp_configs()
	local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
	local lsp_servers = {}

	if vim.fn.isdirectory(lsp_dir) == 1 then
		for _, file in ipairs(vim.fn.readdir(lsp_dir)) do
			if file:match("%.lua$") and file ~= "init.lua" then
				local server_name = file:gsub("%.lua$", "")
				table.insert(lsp_servers, server_name)
			end
		end
	end

	vim.lsp.enable(lsp_servers)
end

return {
	"williamboman/mason.nvim",
	config = function()
		require("mason").setup()

		require("mason-lspconfig").setup({
			ensure_installed = LSP_SERVERS,
		})

		require("mason-tool-installer").setup({
			ensure_installed = TOOLS,
		})

		-- only after mason added bin dir to nvim's runtimepath
		setup_lsp_configs()
	end,

	event = { "BufReadPre", "BufNewFile" },
	enabled = not vim.g.vscode,
	dependencies = {
		{ -- Easier to use lspconfig with mason
			-- https://github.com/williamboman/mason-lspconfig.nvim
			"williamboman/mason-lspconfig.nvim",
		},
		{ -- Install and upgrade 3rd party tools
			-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
	},
}
