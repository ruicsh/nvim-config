-- File tree explorer
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
	"nvim-neo-tree/neo-tree.nvim",
	keys = {
		{ "\\", "<cmd>Neotree source=filesystem toggle reveal<cr>" },
	},
	opts = {
		sync_root_with_cwd = true,
		respect_buf_cwd = true,
		update_focused_file = {
			enable = true,
			update_root = true,
		},
		close_if_last_window = true,
		sources = { "filesystem", "git_status" },
		window = {
			position = "current",
			mappings = {
				["<c-v>"] = { "open_vsplit", desc = "Explorer: Open file to the side" },
				["h"] = { "close_node", desc = "Explorer: Collapse directory" },
				["l"] = { "open", desc = "Explorer: Open file or expand directory" },
				["H"] = { "close_all_nodes", desc = "Explorer: Collapse all" },
				["L"] = { "expand_all_nodes", desc = "Explorer: Expand all" },
				["[c"] = { "prev_git_modified", desc = "Explorer: Previous git change" },
				["]c"] = { "next_git_modified", desc = "Explorer: Next git change" },
			},
		},
		event_handlers = {
			{
				event = "neo_tree_buffer_enter",
				handler = function()
					vim.opt_local.relativenumber = true
				end,
			},
		},
		filesystem = {
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_hidden = false,
				hide_by_pattern = { ".git" },
			},
		},
	},

	cmd = { "Neotree" },
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
}
