-- Test runner
-- https://github.com/vim-test/vim-test

local T = require("lib")

local augroup = vim.api.nvim_create_augroup("ruicsh/plugins/vim-test", { clear = true })

-- Check if the file is an end-to-end test file
local function is_e2e_file(file)
	for _, ext in ipairs({ "js", "jsx", "mjs", "ts", "tsx" }) do
		if string.match(file, "/e2e/.*%." .. ext .. "$") then
			return true
		end
	end
end

-- Auto-set the runner based on current file
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = { "*.js", "*.jsx", "*.mjs", "*.ts", "*.tsx" },
	callback = function()
		if is_e2e_file(vim.fn.expand("%:p")) then
			vim.g["test#javascript#runner"] = "playwright"
		else
			vim.g["test#javascript#runner"] = "vitest"
		end
	end,
})

return {
	"vim-test/vim-test",
	keys = {
		{ "<leader>b%", "<cmd>TestFile<cr>", desc = "Tests: Run file" },
		{ "<leader>ba", "<cmd>TestSuite<cr>", desc = "Tests: Run all" },
		{ "<leader>bb", "<cmd>TestLast<cr>", desc = "Tests: Run last" },
		{ "<leader>bn", "<cmd>TestNearest<cr>", desc = "Tests: Run nearest" },
	},
	config = function()
		-- Enable JavaScript runners: Vitest, Jest, Playwright (faster runner detection)
		vim.g["test#enabled_runners"] = { "javascript#vitest", "javascript#playwright" }

		-- Use npx to run test runners
		vim.g["test#javascript#vitest#executable"] = "npx vitest"
		vim.g["test#javascript#jest#executable"] = "npx jest"

		-- Open side panel with terminal for test output
		vim.g["test#custom_strategies"] = {
			custom = function(cmd)
				T.ui.open_side_panel()

				vim.fn.termopen(cmd) -- Create a terminal buffer and run the command
				vim.cmd("stopinsert") -- Make sure we are not in insert mode
				vim.cmd("normal G") -- Go to the bottom of the terminal output
				vim.cmd("wincmd p") -- Go back to the previous window
			end,
		}

		-- Use custom strategy
		vim.g["test#strategy"] = "custom"
	end,

	cmd = { "TestLast", "TestNearest", "TestFile", "TestSuite" },
}
