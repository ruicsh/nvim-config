-- Test runner
-- https://github.com/vim-test/vim-test

return {
	"vim-test/vim-test",
	keys = function()
		local function run(cmd)
			return function()
				vim.cmd.only()
				vim.cmd(cmd)
			end
		end

		local mappings = {
			{ "<leader>bb", run("TestLast"), "Run last" },
			{ "<leader>bn", run("TestNearest"), "Run nearest" },
			{ "<leader>bf", run("TestFile"), "Run file" },
			{ "<leader>ba", run("TestSuite"), "Run all" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Tests")
	end,
	config = function()
		vim.g["test#strategy"] = "neovim"
		vim.g["test#neovim#term_position"] = "vert"
	end,

	event = "VeryLazy",
	enabled = not vim.g.vscode,
}
