local augroup = vim.api.nvim_create_augroup("ruicsh/ft/typescript", { clear = true })

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript
local function setup_dap()
	local dap = require("dap")

	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = {
				vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/out/src/dapDebugServer.js",
				"${port}",
			},
		},
	}

	dap.configurations.typescript = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
			args = { "${file}" },
			sourceMaps = true,
			sourceMapPathOverrides = {
				["./*"] = "${workspaceFolder}/src/*",
			},
		},
	}
end

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "typescript",
	callback = function()
		setup_dap()
	end,
})
