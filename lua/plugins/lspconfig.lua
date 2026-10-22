-- Native LSP configuration
-- https://github.com/neovim/nvim-lspconfig

-- Tailwind CSS
local function tailwindcss_opts()
	local tailwind_config = vim.lsp.config.tailwindcss
	local tailwind_root_dir = tailwind_config.root_dir

	return {
		filetypes = vim.tbl_filter(function(filetype)
			-- Ignore markdown and mdx
			return filetype ~= "markdown" and filetype ~= "mdx"
		end, tailwind_config.filetypes),
		root_dir = function(bufnr, on_dir)
			tailwind_root_dir(bufnr, function(root_dir)
				if root_dir then
					root_dir = vim.fs.normalize(vim.fn.fnamemodify(root_dir, ":p"))
				end

				on_dir(root_dir)
			end)
		end,
		settings = {
			tailwindCSS = {
				classFunctions = { "cva", "cx", "tv" },
			},
		},
	}
end

return {
	"neovim/nvim-lspconfig",
	cond = not os.getenv("NVIM_GIT_DIFF"),
	opts = function()
		return {
			servers = {
				tailwindcss = tailwindcss_opts(),
			},
		}
	end,
	config = function(_, opts)
		for server, server_opts in pairs(opts.servers) do
			vim.lsp.config(server, server_opts)
		end
	end,
}
