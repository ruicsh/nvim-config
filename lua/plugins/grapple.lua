-- File bookmarks
-- https://github.com/cbochs/grapple.nvim

return {
	"cbochs/grapple.nvim",
	keys = function()
		local mappings = {
			{ "<leader>,", "<cmd>Grapple toggle_tags<cr>", "Toggle menu" },
			{ ",l", "<cmd>Grapple toggle<cr>", "Toggle" },
			{ "[,", "<cmd>Grapple cycle_tags prev<cr>", "Previous" },
			{ "],", "<cmd>Grapple cycle_tags next<cr>", "Next" },
		}

		-- Add markings for easier access and saving
		for i, key in ipairs({ "a", "s", "d", "f" }) do
			local cmd = string.format("<cmd>Grapple select index=%d<cr>", i)
			local desc = "Select " .. key
			table.insert(mappings, { "," .. i, cmd, desc })
			table.insert(mappings, { "," .. key, cmd, desc })

			local saveCmd = string.format("<cmd>Grapple tag index=%d<cr>", i)
			table.insert(mappings, { ",<c-" .. key .. ">", saveCmd, "Tag " .. key })
		end

		return vim.fn.get_lazy_keys_conf(mappings, "Bookmarks")
	end,
	opts = {
		name_pos = "start",
		quick_select = "asdf",
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
