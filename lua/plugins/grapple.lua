-- File bookmarks
-- https://github.com/cbochs/grapple.nvim

return {
	"cbochs/grapple.nvim",
	keys = function()
		local grapple = require("grapple")

		local mappings = {
			{ "<leader>,,", "<cmd>Grapple toggle_tags<cr>", "Toggle menu" },
		}

		local function jump_to_tag(index)
			return function()
				local tag = grapple.find({ index = index })
				if tag then
					-- Check if the file is already open in any window
					for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
						local buf = vim.api.nvim_win_get_buf(win)
						local buf_name = vim.api.nvim_buf_get_name(buf)
						if buf_name == tag.path then
							-- If found, jump to that window
							vim.api.nvim_set_current_win(win)
							return
						end
					end
				end

				-- If not, open the file and jump to the tag
				grapple.select({ index = index })
			end
		end

		-- Add markings for easier access and saving
		for index, key in ipairs({ "a", "s", "d", "f", "g" }) do
			table.insert(mappings, { "," .. key, jump_to_tag(index), "Jump to " .. key })

			local saveCmd = string.format("<cmd>Grapple tag index=%d name=%s<cr>", index, key)
			table.insert(mappings, { "<leader>," .. key, saveCmd, "Save " .. key })
		end

		return vim.fn.get_lazy_keys_conf(mappings, "Bookmarks")
	end,
	opts = {
		name_pos = "",
		quick_select = "asdfg",
		scope = "git_branch",
		win = {
			border = "rounded",
		},
	},

	cmd = { "Grapple" },
	dependncies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
}
