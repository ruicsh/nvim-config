-- Git client
-- https://github.com/tpope/vim-fugitive

return {
	"tpope/vim-fugitive",
	keys = function()
		local function open_git_status()
			vim.cmd("only")
			vim.cmd("vertical Git")
		end

		local mappings = {
			{ "<leader>hh", open_git_status, "Status" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Git")
	end,
}
