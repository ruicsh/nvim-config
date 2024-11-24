-----
-- Debug
-----

local function set_dap_icons()
	for name, sign in pairs(ThisNvimConfig.icons.dap) do
		sign = type(sign) == "table" and sign or { sign }
		vim.fn.sign_define(
			"Dap" .. name,
			{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
		)
	end
end

local function set_dap_configs(dap)
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
end

return {
	{ -- DAP client implementation (nvim-dap)
		-- https://github.com/mfussenegger/nvim-dap
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
			set_dap_icons()
			set_dap_configs(dap)
		end,

		event = { "BufEnter" },
	},

	{ -- adapter for vscode-js-debug
		-- https://github.com/mxsdev/nvim-dap-vscode-js
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

		event = { "BufEnter" },
		dependencies = {
			{ -- JS debugger (vscode-js-debug)
				-- https://github.com/microsoft/vscode-js-debug
				"microsoft/vscode-js-debug",
				build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
				version = "1.*",
			},
		},
	},

	{ -- User interface (nvim-dap-ui).
		-- https://github.com/rcarriga/nvim-dap-ui
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

		event = { "BufEnter" },
		dependencies = {
			"nvim-neotest/nvim-nio",
		},
	},

	{ -- Virtual text (nvim-dap-virtual-text).
		-- https://github.com/theHamsta/nvim-dap-virtual-text
		"theHamsta/nvim-dap-virtual-text",
		opts = {},

		event = { "BufEnter" },
	},

	{ -- Log statements (debugprint.nvim).
		-- https://github.com/andrewferrier/debugprint.nvim
		"andrewferrier/debugprint.nvim",
		opts = {
			print_tag = "ruic",
			keymaps = {
				normal = {
					plain_below = "g?p",
					plain_above = "g?P",
					variable_below = "g?v",
					variable_above = "g?V",
					variable_below_alwaysprompt = nil,
					variable_above_alwaysprompt = nil,
					textobj_below = "g?o",
					textobj_above = "g?O",
					toggle_comment_debug_prints = nil,
					delete_debug_prints = nil,
				},
				visual = {
					variable_below = "g?v",
					variable_above = "g?V",
				},
			},
			commands = {
				toggle_comment_debug_prints = "ToggleCommentDebugPrints",
				delete_debug_prints = "DeleteDebugPrints",
			},
			filetypes = {
				["javascript"] = { display_location = false },
				["javascriptreact"] = { display_location = false },
				["typescript"] = { display_location = false },
				["typescriptreact"] = { display_location = false },
			},
		},

		main = "debugprint",
		event = { "BufEnter" },
	},
}
