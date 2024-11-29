-- User interface
-- https://github.com/rcarriga/nvim-dap-ui

return {
	"rcarriga/nvim-dap-ui",
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()

		dap.listeners.before.attach.dapui_config = function()
			vim.cmd("VimadeDisable") -- Disable dimming windows.
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			vim.cmd("VimadeDisable") -- Disable dimming windows.
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			vim.cmd(":VimadeEnable") -- Reenable dimming windows.
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			vim.cmd(":VimadeEnable") -- Reenable dimming windows.
			dapui.close()
		end
	end,

	event = { "VeryLazy" },
	dependencies = {
		"nvim-neotest/nvim-nio",
	},
}
