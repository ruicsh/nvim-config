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
	handlers = {
		["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
			focus = true,
			max_width = 80,
		}),
		["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
			focus = true,
			max_width = 80,
		}),
		["$/progress"] = function(_, result, ctx)
			local client_id = ctx.client_id
			local token = result.token
			local value = result.value

			-- initialize client entry
			if not _G.lsp_progress[client_id] then
				_G.lsp_progress[client_id] = {}
			end

			if value.kind == "begin" or value.kind == "report" then
				-- Update progress message
				_G.lsp_progress[client_id][token] = {
					title = value.title or "",
				}
				if value.message and value.message ~= "" then
					_G.lsp_progress[client_id][token].message = value.message
				end
			elseif value.kind == "end" then
				vim.defer_fn(function()
					_G.lsp_progress[client_id][token] = nil
					vim.cmd("redrawstatus")
				end, 3000)
			end

			vim.cmd("redrawstatus")
		end,
	},
}

return M
