--
-- LSP
--

-- Set keymaps for LSP commands.
local function set_keymaps(event)
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

	local telescope = require("telescope.builtin")

	-- When displaying the document/worspace symbols, only show these.
	local lsp_symbols = { "method", "function", "class" }
	local function lsp_document_symbols()
		telescope.lsp_document_symbols({ symbols = lsp_symbols })
	end
	local function lsp_workspace_symbols()
		telescope.lsp_workspace_symbols({ symbols = lsp_symbols })
	end
	local function lsp_references()
		telescope.lsp_references({
			include_declaration = false,
			show_line = false,
		})
	end

	map("K", "<cmd>lua vim.lsp.buf.hover()<cr>", "LSP: Display hover for symbol")
	map("gd", telescope.lsp_definitions, "LSP: Jump to [d]efinition")
	map("gi", telescope.lsp_implementations, "LSP: Jump to [i]mplementation")
	map("go", telescope.lsp_type_definitions, "LSP: Jump to type definition")
	map("gr", lsp_references, "LSP: List [r]eferences")
	map("gy", lsp_document_symbols, "LSP: Document s[y]mbols")
	map("gY", lsp_workspace_symbols, "LSP: Workspace s[Y]mbols")
	map("<f2>", vim.lsp.buf.rename, "LSP: Rename symbol")
end

-- Install and configure lsp servers.
local function conf_lsp_servers()
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
	local servers = {
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
	}

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	require("mason").setup()

	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		"prettierd", -- As a deamon, used to format JS/TS/CSS
		"stylua", -- Used to format Lua code.
	})
	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

	require("mason-lspconfig").setup({
		handlers = {
			function(server_name)
				local server = servers[server_name] or {}
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				require("lspconfig")[server_name].setup(server)
			end,
		},
	})
end

local function set_lsp_diagnostics_icons()
	for _, diag in ipairs({ "Error", "Warn", "Info", "Hint" }) do
		vim.fn.sign_define("DiagnosticSign" .. diag, {
			text = ThisNvimConfig.icons.diagnostics[diag],
			texthl = "DiagnosticSign" .. diag,
			linehl = "",
			numhl = "DiagnosticSign" .. diag,
		})
	end
end

return {
	{ -- Config (nvim-lspconfig).
		-- https://github.com/neovim/nvim-lspconfig
		"neovim/nvim-lspconfig",
		config = function()
			set_lsp_diagnostics_icons()

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					set_keymaps(event)
				end,
			})

			conf_lsp_servers()
		end,

		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "pmizio/typescript-tools.nvim", opts = {} },
			{ "onsails/lspkind.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
	},

	{ -- Jump to reference (refjump.nvim).
		-- https://github.com/mawkler/refjump.nvim
		"mawkler/refjump.nvim",
		opts = {
			highlights = {
				enabled = false,
			},
		},

		event = { "BufReadPost", "BufNewFile" },
	},

	{ -- Diagnostics (trouble.nvim).
		-- https://github.com/folke/trouble.nvim
		"folke/trouble.nvim",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Trouble: Diagnostics",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Trouble: Location List",
			},
		},
		opts = {
			focus = true,
		},

		cmd = "Trouble",
	},

	{ -- Neovim apis lsp (lazydev.nvim).
		-- Used for completion, annotations and signatures of Neovim APIs.
		-- https://github.com/folke/lazydev.nvim
		"folke/lazydev.nvim",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},

		lazy = true,
		ft = "lua",
	},
}
