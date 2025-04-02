-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/ansiblels.lua

return {
	cmd = {
		"ansible-language-server",
		"--stdio",
	},
	filetypes = {
		"yaml.ansible",
	},
	root_markers = {
		"ansible.cfg",
		".ansible-lint",
	},
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

	single_file_support = true,
}
