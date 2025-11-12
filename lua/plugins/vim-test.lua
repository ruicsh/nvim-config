-- Test runner
-- https://github.com/vim-test/vim-test

return {
	"vim-test/vim-test",
	keys = function()
		local close_test_output = function()
			vim.ux.close_floating_panel("is_vimtest")
		end

		local mappings = {
			{ "<leader>b%", ":TestFile<cr>", "Run file" },
			{ "<leader>ba", ":TestSuite<cr>", "Run all" },
			{ "<leader>bb", ":TestLast<cr>", "Run last" },
			{ "<leader>bn", ":TestNearest<cr>", "Run nearest" },
			{ "<leader>bq", close_test_output, "Close output" },
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
				vim.ux.open_floating_panel({ winid = "is_vimtest" })

				-- Create a terminal buffer and run the command
				vim.fn.termopen(cmd)

				vim.cmd.wincmd("p") -- Go back to the previous window
				vim.cmd.stopinsert() -- Make sure we are not in insert mode
			end,
		}

		-- Use custom strategy
		vim.g["test#strategy"] = "my_neovim"
	end,

	cmd = { "TestLast", "TestNearest", "TestFile", "TestSuite" },
}
