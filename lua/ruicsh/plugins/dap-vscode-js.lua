-- Adapter for vscode-js-debug
-- https://github.com/mxsdev/nvim-dap-vscode-js

return {
	"mxsdev/nvim-dap-vscode-js",
	config = function()
		require("dap-vscode-js").setup({
			-- Path to vscode-js-debug installation.
			debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
			-- which adapters to register in nvim-dap
			adapters = {
				"chrome",
				"pwa-node",
				"pwa-chrome",
				"pwa-msedge",
				"pwa-extensionHost",
				"node-terminal",
			},
		})
	end,

	event = { "VeryLazy" },
	dependencies = {
		{ -- JS debugger
			-- https://github.com/microsoft/vscode-js-debug
			"microsoft/vscode-js-debug",
			build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
			version = "1.*",
		},
	},
}
