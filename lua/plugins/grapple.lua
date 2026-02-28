-- File bookmarks
-- https://github.com/cbochs/grapple.nvim

return {
	"cbochs/grapple.nvim",
	keys = function()
		local grapple = require("grapple")

		local function jump_to_tag(name)
			return function()
				local tag = grapple.find({ name = name })
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
				grapple.select({ name = name })
			end
		end

		local function toggle_tag(name)
			return function()
				if grapple.exists({ name = name }) then
					grapple.untag({ name = name })
				else
					grapple.tag({ name = name })
				end

				vim.cmd("redrawstatus")
			end
		end

		local mappings = {
			{ "<leader><bslash>", "<cmd>Grapple toggle_tags<cr>", desc = "Bookmarks: Toggle menu" },
		}

		-- Add markings for easier access and saving
		for _, name in ipairs({ "a", "s", "d", "f", "g", "h", "j", "k", "l" }) do
			table.insert(mappings, { "<bslash>" .. name, jump_to_tag(name), desc = "Bookmarks: Jump to " .. name })
			table.insert(
				mappings,
				{ "<bslash><bslash>" .. name, toggle_tag(name), desc = "Bookmarks: Toggle " .. name }
			)
		end

		return mappings
	end,
	opts = {
		name_pos = "start",
		quick_select = "",
		scope = "git_branch",
		win_opts = {
			border = "rounded",
			width = 0.6,
		},
	},

	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
}
