-- Git client
-- https://github.com/tpope/vim-fugitive

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

		return {
			{ "<leader>hH", git_status, desc = "Git: Status" },
			{ "<leader>hd", git_diff_file, desc = "Git: Diff file" },
		}
	end,

	event = "VeryLazy",
}
