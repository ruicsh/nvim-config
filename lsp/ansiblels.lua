-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ansiblels.lua

---@type vim.lsp.Config
return {
	cmd = { "ansible-language-server", "--stdio" },
	settings = {
		ansible = {
			python = {
				interpreterPath = "python",
			},
			ansible = {
				path = "ansible",
			},
			executionEnvironment = {
				enabled = false,
			},
			validation = {
				enabled = true,
				lint = {
					enabled = true,
					path = "ansible-lint",
				},
			},
		},
	},
	filetypes = { "yaml.ansible" },
	root_markers = { "ansible.cfg", ".ansible-lint" },
}
