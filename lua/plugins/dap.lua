-- DAP client implementation
-- https://github.com/mfussenegger/nvim-dap

local icons = require("config/icons")

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
			{ "<leader>ki", widgets.hover, desc = "Widgets" },

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

		-- icons
		for name, sign in pairs(icons.dap) do
			sign = type(sign) == "table" and sign or { sign }
			vim.fn.sign_define(
				"Dap" .. name,
				{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
			)
		end

		-- dap config
		local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

		for _, language in ipairs(js_based_languages) do
			dap.configurations[language] = {
				{ -- Debug single nodejs files
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMaps = true,
				},
				{ -- debug nodejs processes (make sure to add --inspect when you run the process)
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
				},
				{ -- Debug web applications (chrome)
					type = "pwa-chrome",
					request = "launch",
					name = "Chrome",
					url = function()
						local co = coroutine.running()
						return coroutine.create(function()
							vim.ui.input({
								prompt = "Enter URL: ",
								default = "http://localhost:3000",
							}, function(url)
								if url == nil or url == "" then
									return
								else
									coroutine.resume(co, url)
								end
							end)
						end)
					end,
					webRoot = "${workspaceFolder}",
					protocol = "inspector",
					sourceMaps = true,
					userDataDir = false,
				},
			}
		end
	end,

	event = { "VeryLazy" },
}
