-- Git client
-- https://github.com/tpope/vim-fugitive

return {
	"tpope/vim-fugitive",
	keys = function()
		local function open_git_status()
			vim.cmd.tabnew()
			vim.cmd("vertical Git")
			vim.cmd.only()
		end

		return {
			{ "<leader>hH", open_git_status, desc = "Git: Status" },
		}
	end,

	event = "VeryLazy",
}
