local augroup = vim.api.nvim_create_augroup("ruicsh/filetype/typescript", { clear = true })

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript
local function setup_dap()
	local dap = package.loaded.dap

	if not dap.adapters["pwa-node"] then
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = {
					vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
					"${port}",
				},
			},
		}
	end

	if not dap.adapters["node"] then
		dap.adapters["node"] = function(cb, config)
			if config.type == "node" then
				config.type = "pwa-node"
			end
			local nativeAdapter = dap.adapters["pwa-node"]
			if type(nativeAdapter) == "function" then
				nativeAdapter(cb, config)
			else
				cb(nativeAdapter)
			end
		end
	end

	dap.configurations.typescript = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
			args = { "${file}" },
			-- sourceMaps = true,
			-- sourceMapPathOverrides = {
			-- 	["./*"] = "${workspaceFolder}/src/*",
			-- },
		},
	}
end

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "typescript", "typescriptreact", "typescript.tsx" },
	callback = function()
		if not vim.g.vscode then
			setup_dap()
		end
	end,
})
