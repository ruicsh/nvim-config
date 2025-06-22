-- DAP client implementation
-- https://github.com/mfussenegger/nvim-dap

-- Setup DAP icons for debugging
local function setup_icons()
	local icons = {
		Stopped = "",
		Breakpoint = "",
	}
	for name, sign in pairs(icons) do
		name = "Dap" .. name
		vim.fn.sign_define(name, {
			text = sign .. " ",
			texthl = name,
			linehl = name .. "Line",
			numhl = name .. "LineNr",
		})
	end
end

return {
	"mfussenegger/nvim-dap",
	keys = function()
		local dap = require("dap")

		local function start_session()
			dap.toggle_breakpoint()
			dap.continue()
		end

		local mappings = {
			{ "<leader>dd", start_session, "Start session with breakpoint" },
			{ "<leader>db", dap.toggle_breakpoint, "Toggle Breakpoint" },
			{ "<d-bslash>", dap.continue, "Run/Continue" },
			{ "<d-s-bslash>", dap.terminate, "Stop session" },
			{ "<d-'>", dap.step_over, "Step Over" },
			{ "<d-;>", dap.step_into, "Step Into" },
			{ "<d-s-;>", dap.step_out, "Step Out" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Debug")
	end,
	config = function()
		local dap = package.loaded.dap
		local dv = require("dap-view")

		setup_icons()

		-- Auto-open dapui when debugging session starts
		local is_dapview_open = false
		dap.listeners.before.launch.dapui_config = function()
			if not is_dapview_open then
				vim.cmd.only()
				dv.open()
				is_dapview_open = true
			end
		end

		-- Auto-close dapui when debugging session ends
		dap.listeners.before.event_terminated.dapui_config = function()
			if is_dapview_open then
				dv.close()
				is_dapview_open = false
			end
		end
	end,

	enabled = not vim.g.vscode,
	dependencies = {
		{
			"igorlfs/nvim-dap-view",
			opts = {
				winbar = {
					default_section = "scopes",
				},
				windows = {
					height = vim.o.lines - 4,
					position = "right",
					terminal = {
						hide = { "node", "pwa-node" },
					},
				},
			},
		},
	},
}
