-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/cssmodules_ls.lua

return {
	cmd = {
		"cssmodules-language-server",
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_markers = {
		"package.json",
	},
	root_dir = function(bufnr, on_dir)
		local filename = vim.api.nvim_buf_get_name(bufnr)
		-- Only attach if there's a corresponding *.module.scss or *.module.css file.
		local has_module = vim.fs.find(
			{ filename:gsub("%.tsx?$", ".module.scss"), filename:gsub("%.tsx?$", ".module.css") },
			{ path = filename }
		)
		if #has_module == 0 then
			return nil
		end

		-- Only attach if there's some package.json in the root directory.
		local root_dir = vim.fs.dirname(vim.fs.find("package.json", { path = filename, upward = true })[1])
		if not root_dir then
			return nil
		end

		on_dir(root_dir)
	end,
}
