-- Test runner
-- https://github.com/vim-test/vim-test

local T = require("lib")

return {
	"vim-test/vim-test",
	keys = {
		{ "<leader>b%", "<cmd>TestFile<cr>", desc = "Tests: Run file" },
		{ "<leader>ba", "<cmd>TestSuite<cr>", desc = "Tests: Run all" },
		{ "<leader>bb", "<cmd>TestLast<cr>", desc = "Tests: Run last" },
		{ "<leader>bn", "<cmd>TestNearest<cr>", desc = "Tests: Run nearest" },
	},
	config = function()
		-- Use npx to run test runners
		vim.g["test#javascript#vitest#executable"] = "npx vitest"
		vim.g["test#javascript#jest#executable"] = "npx jest"

		-- Open side panel with terminal for test output
		vim.g["test#custom_strategies"] = {
			my_neovim = function(cmd)
				T.ui.open_side_panel()

				vim.fn.termopen(cmd) -- Create a terminal buffer and run the command
				vim.cmd.stopinsert() -- Make sure we are not in insert mode
				vim.cmd.normal("G") -- Go to the bottom of the terminal output
				vim.cmd.wincmd("p") -- Go back to the previous window
			end,
		}

		-- Use custom strategy
		vim.g["test#strategy"] = "my_neovim"
	end,

	cmd = { "TestLast", "TestNearest", "TestFile", "TestSuite" },
}
