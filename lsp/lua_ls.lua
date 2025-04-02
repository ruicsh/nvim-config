-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/lua_ls.lua

return {
	cmd = {
		"lua-language-server",
	},
	filetypes = {
		"lua",
	},
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
	settings = {
		Lua = {
			diagnostics = {
				disable = { "missing-parameters", "missing-fields" },
			},
		},
	},

	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
}
