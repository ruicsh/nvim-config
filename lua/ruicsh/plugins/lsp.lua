--
-- LSP
--

-- Set keymaps for LSP commands.
local function set_keymaps(event)
	local k = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

	local telescope = require("telescope.builtin")

	-- When displaying the document/worspace symbols, only show these.
	local function lsp_references()
		telescope.lsp_references({
			include_declaration = false,
			show_line = false,
		})
	end

	k("K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Display hover for symbol")
	k("<c-K>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Display signature help", "i")
	k("gd", telescope.lsp_definitions, "Jump to [d]efinition")
	k("gi", telescope.lsp_implementations, "Jump to [i]mplementation")
	k("go", telescope.lsp_type_definitions, "Jump to type definition")
	k("gr", lsp_references, "List [r]eferences")
	k("<f2>", vim.lsp.buf.rename, "Rename symbol")
	k("[d", vim.diagnostic.goto_prev, "Jump to previous [d]iagnostic")
	k("]d", vim.diagnostic.goto_next, "Jump to next [d]iagnostic")
	k("<leader>ca", vim.lsp.buf.code_action, "Code actions")
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

				local conf = vim.tbl_deep_extend("force", server, {
					capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {}),
					handlers = {
						-- <s-k> float window
						["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
							border = "rounded",
						}),
						-- i_<c-k> float window
						["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
							border = "rounded",
						}),
					},
					on_attach = function(client, bufnr)
						if client.server_capabilities["documentSymbolProvider"] then
							-- Add navic to barbecue
							require("nvim-navic").attach(client, bufnr)
						end
					end,
				})

				require("lspconfig")[server_name].setup(conf)
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
	{ -- LSP config (nvim-lspconfig).
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

		event = { "BufEnter" },
		dependencies = {
			{ -- LSP package manager
				-- https://github.com/williamboman/mason.nvim
				"williamboman/mason.nvim",
			},
			{ -- Easier to use lspconfig with mason
				-- https://github.com/williamboman/mason-lspconfig.nvim
				"williamboman/mason-lspconfig.nvim",
			},
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "pmizio/typescript-tools.nvim", opts = {} },
			{ "onsails/lspkind.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
	},

	{ -- LSP symbols
		-- https://github.com/hedyhli/outline.nvim
		"hedyhli/outline.nvim",
		keys = {
			{ "gy", "<cmd>Outline<cr>", desc = "LSP: symbols" },
		},
		opts = {
			outline_items = {
				show_symbol_lineno = true,
			},
			outline_window = {
				auto_jump = true,
			},
			symbols = {
				icon_source = "lspkind",
			},
		},

		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		requirements = {
			{ "onsails/lspkind.nvim" },
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

		event = { "BufEnter" },
	},

	{ -- Diagnostics (trouble.nvim).
		-- https://github.com/folke/trouble.nvim
		"folke/trouble.nvim",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Trouble: Diagnostics",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Trouble: Workspace diagnostics",
			},
		},
		opts = {
			focus = true,
		},

		lazy = true,
		cmd = { "Trouble" },
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
