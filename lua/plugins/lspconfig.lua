-- Native LSP configuration
-- https://github.com/neovim/nvim-lspconfig

return {
	"neovim/nvim-lspconfig",
	enabled = not os.getenv("NVIM_GIT_DIFF"),
	opts = {
		servers = {
			tailwindcss = {
				settings = {
					tailwindCSS = {
						classFunctions = { "cva", "cx", "tv" },
					},
				},
			},
		},
	},
	config = function(_, opts)
		for server, server_opts in pairs(opts.servers) do
			vim.lsp.config(server, server_opts)
		end
	end,

	lazy = false,
}
