-- Test runner
-- https://github.com/vim-test/vim-test

return {
	"vim-test/vim-test",
	keys = function()
		local mappings = {
			{ "<leader>bb", ":TestLast<cr>", "Run last" },
			{ "<leader>bn", ":TestNearest<cr>", "Run nearest" },
			{ "<leader>bf", ":TestFile<cr>", "Run file" },
			{ "<leader>ba", ":TestSuite<cr>", "Run all" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Tests")
	end,
	config = function()
		vim.g["test#custom_strategies"] = {
			my_neovim = function(cmd)
				-- Open a new vertical split for the terminal
				vim.ui.open_side_panel()

				-- Run the test command
				vim.fn.jobstart(cmd, {
					term = true,
				})

				-- Set buffer-local variable so that terminal doesn't enter insert mode
				local bufnr = vim.api.nvim_get_current_buf()
				vim.api.nvim_buf_set_var(bufnr, "is_vimtest_terminal", true)

				vim.cmd.wincmd("p") -- Go back to the previous window
				vim.cmd.stopinsert() -- Make sure we are not in insert mode
			end,
		}

		-- Use custom strategy
		vim.g["test#strategy"] = "my_neovim"
	end,

	event = "VeryLazy",
	enabled = not vim.g.vscode,
}
