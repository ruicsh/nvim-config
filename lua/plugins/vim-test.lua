-- Test runner
-- https://github.com/vim-test/vim-test

return {
	"vim-test/vim-test",
	keys = function()
		local mappings = {
			{ "<leader>b%", ":TestFile<cr>", "Run file" },
			{ "<leader>ba", ":TestSuite<cr>", "Run all" },
			{ "<leader>bb", ":TestLast<cr>", "Run last" },
			{ "<leader>bn", ":TestNearest<cr>", "Run nearest" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Tests")
	end,
	config = function()
		-- Use npx to run test runners
		vim.g["test#javascript#vitest#executable"] = "npx vitest"
		vim.g["test#javascript#jest#executable"] = "npx jest"

		-- Open side panel with terminal for test output
		vim.g["test#custom_strategies"] = {
			my_neovim = function(cmd)
				vim.ux.open_side_panel({
					padding_left = 2,
				})

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
