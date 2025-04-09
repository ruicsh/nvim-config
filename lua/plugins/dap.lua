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

		local mappings = {
			{ "<f5>", dap.continue, "Run/Continue" },
			{ "<f17>", dap.terminate, "Stop" }, -- <s-f5>
			{ "<f9>", dap.toggle_breakpoint, "Toggle Breakpoint" },
			{ "<f10>", dap.step_over, "Step Over" },
			{ "<f11>", dap.step_into, "Step Into" },
			{ "<f23>", dap.step_out, "Step Out" }, -- <s-f11>

			{ "<c-k><c-i>", widgets.hover, "Widgets" },
			{ "<leader>dB", set_breakpoint_condition, "Breakpoint Condition" },
			{ "<leader>dC", dap.run_to_cursor, "Run to Cursor" },
			{ "<leader>da", start_with_args, "Run with args" },
			{ "<leader>dg", dap.goto_, "Go to Line (No Execute)" },
			{ "<leader>dj", dap.down, "Down" },
			{ "<leader>dk", dap.up, "Up" },
			{ "<leader>dl", dap.run_last, "Run Last" },
			{ "<leader>dp", dap.pause, "Pause" },
			{ "<leader>dr", dap.repl.toggle, "Toggle REPL" },
			{ "<leader>ds", dap.session, "Session" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Debug")
	end,
	config = function()
		local dap = package.loaded.dap
		local dapui = package.loaded.dapui

		-- Setup icons
		for name, sign in pairs(icons.dap) do
			name = "Dap" .. name
			vim.fn.sign_define(name, {
				text = sign,
				texthl = name,
				linehl = name .. "Line",
				numhl = name .. "LineNr",
			})
		end

		-- Auto-open dapui when debugging session starts
		local is_dapui_open = false
		dap.listeners.before.launch.dapui_config = function()
			if not is_dapui_open then
				vim.cmd.tabnew()
				dapui.open()
				is_dapui_open = true
			end
		end

		-- Auto-close dapui when debugging session ends
		dap.listeners.before.event_terminated.dapui_config = function()
			if is_dapui_open then
				dapui.close()
				-- Only close the tab if it's not the last one
				if vim.fn.tabpagenr("$") > 1 then
					vim.cmd.tabclose()
				end
				is_dapui_open = false
			end
		end
	end,

	dependencies = {
		{ -- User interface
			-- https://github.com/rcarriga/nvim-dap-ui
			"rcarriga/nvim-dap-ui",
			opts = {
				expand_lines = false,
				layouts = {
					{
						position = "right",
						size = 0.5,
						elements = {
							{ id = "scopes", size = 0.5 },
							{ id = "stacks", size = 0.2 },
							{ id = "watches", size = 0.2 },
							{ id = "breakpoints", size = 0.1 },
						},
					},
					{
						position = "bottom",
						size = 10,
						elements = {
							{ id = "repl" },
						},
					},
				},
			},

			dependencies = { "nvim-neotest/nvim-nio" },
		},
	},
}
