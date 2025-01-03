-- Directory editor
-- https://github.com/stevearc/oil.nvim

return {
	"stevearc/oil.nvim",
	keys = function()
		local oil = require("oil")
		local function open_cwd()
			oil.open(vim.fn.getcwd())
		end

		local mappings = {
			{ "-", ":Oil<cr>", "Open parent" },
			{ "_", open_cwd, "Open cwd" },
		}
		return vim.fn.getlazykeysconf(mappings, "Oil")
	end,
	opts = {
		buf_options = {
			buflisted = false,
			bufhidden = "hide",
		},
		columns = {
			{ "icon", add_padding = false },
		},
		constrain_cursor = "name",
		default_file_explorer = true,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		keymaps = {
			["g?"] = "actions.show_help",
			["<cr>"] = "actions.select",
			["<c-v>"] = {
				"actions.select",
				opts = { vertical = true },
				desc = "Oil: Open the entry in a vertical split",
			},
			["<c-s>"] = {
				"actions.select",
				opts = { horizontal = true },
				desc = "Oil: Open the entry in a horizontal split",
			},
			["<c-t>"] = { "actions.select", opts = { tab = true }, desc = "Oil: Open the entry in new tab" },
			["<c-p>"] = "actions.preview",
			["<c-l>"] = "actions.refresh",
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["~"] = {
				"actions.cd",
				opts = { scope = "tab" },
				desc = "Oil: :tcd to the current oil directory",
				mode = "n",
			},
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
		},
		view_options = {
			show_hidden = true,
		},
	},

	cmd = { "Oil" },
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
}
