-- Git client
-- https://github.com/tpope/vim-fugitive

local T = require("lib")

return {
	"tpope/vim-fugitive",
	keys = function()
		local function git_status()
			vim.cmd("tabnew")
			vim.cmd("vertical Git")
			vim.cmd("only")
		end

		local function git_diff_file()
			local line_content = vim.api.nvim_get_current_line()
			vim.cmd("Git diff HEAD %")
			-- Escape special chars for search
			local pattern = vim.fn.escape(line_content, [[\/.*$^~[]])
			-- Search for the line content in the diff buffer
			vim.fn.search(pattern, "w")
		end

		local function show_range_history()
			local start_line = vim.fn.line("v")
			local end_line = vim.fn.line(".")
			local file_path = vim.fn.expand("%")
			local range = string.format("%s,%s", start_line, end_line)
			local cmd = string.format("Git log -L %s:%s", range, file_path)

			T.ui.open_side_panel({ cmd = cmd, mode = "replace" })
		end

		return {
			{ "<leader>hd", git_diff_file, desc = "Git: Diff file" },
			{ "<leader>hH", git_status, desc = "Git: Status" },
			{ "<leader>hl", show_range_history, mode = "v", desc = "Git: Show range history" },
		}
	end,

	event = "VeryLazy",
}
