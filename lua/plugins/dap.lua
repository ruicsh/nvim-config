-- DAP client implementation
-- https://github.com/mfussenegger/nvim-dap

local icons = require("config.icons")

return {
	"mfussenegger/nvim-dap",
	keys = function()
		local dap = require("dap")
		local widgets = require("dap.ui.widgets")

		local function set_breakpoint_condition()
			local input = vim.fn.input("Breakpoint condition: ")
			dap.set_breakpoint(input)
		end

		local function start_with_args()
			dap.continue({ before = "get_args" })
		end

		return {
			{ "<c-9>", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
			{ "<c-5>", dap.continue, desc = "Debug: Run/Continue" },
			{ "<c-s-5>", dap.terminate, desc = "Debug: Stop" },
			{ "<c-->", dap.step_into, desc = "Step Into" },
			{ "<c-s-->", dap.step_out, desc = "Step Out" },
			{ "<c-0>", dap.step_over, desc = "Step Over" },
			{ "<c-k><c-i>", widgets.hover, desc = "Widgets" },

			{ "<leader>dB", set_breakpoint_condition, desc = "Debug: Breakpoint Condition" },
			{ "<leader>dC", dap.run_to_cursor, desc = "Debug: Run to Cursor" },
			{ "<leader>da", start_with_args, desc = "Debug: Run with args" },
			{ "<leader>dg", dap.goto_, desc = "Debug: Go to Line (No Execute)" },
			{ "<leader>dj", dap.down, desc = "Debug: Down" },
			{ "<leader>dk", dap.up, desc = "Debug: Up" },
			{ "<leader>dl", dap.run_last, desc = "Debug: Run Last" },
			{ "<leader>dp", dap.pause, desc = "Debug: Pause" },
			{ "<leader>dr", dap.repl.toggle, desc = "Debug: Toggle REPL" },
			{ "<leader>ds", dap.session, desc = "Debug: Session" },
		}
	end,
	config = function()
		local dap = require("dap")

		-- Setup icons
		for name, sign in pairs(icons.dap) do
			name = "Dap" .. name
			vim.fn.sign_define(name, { text = sign, texthl = name, linehl = "", numhl = "" })
		end

		-- Auto-open dapui when debugging session starts
		dap.listeners.after.event_initialized["dapui_config"] = function()
			require("dapui").open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			require("dapui").close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			require("dapui").close()
		end
	end,

	dependencies = {
		{ -- User interface (nvim-dap-ui).
			-- https://github.com/rcarriga/nvim-dap-ui
			"rcarriga/nvim-dap-ui",
			opts = {},

			dependencies = {
				"nvim-neotest/nvim-nio",
			},
		},
	},
}
