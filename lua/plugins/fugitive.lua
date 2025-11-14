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

		local mappings = {
			{ "<leader>hH", open_git_status, "Status" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Git")
	end,

	event = "VeryLazy",
}
