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

		return vim.fn.get_lazy_keys_conf(mappings, "Oil")
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
		keymaps = {
			["-"] = "actions.parent",
			["<c-w>s"] = "actions.select_split",
			["<c-w>t"] = "actions.select_tab",
			["<c-w>v"] = "actions.select_vsplit",
			["<cr>"] = "actions.select",
			["_"] = "actions.open_cwd",
			["g?"] = "actions.show_help",
			["gs"] = "actions.change_sort",
			["q"] = "actions.close",
		},
		skip_confirm_for_simple_edits = true,
		use_default_keymaps = false,
		view_options = {
			is_always_hidden = function(name, _)
				return name == "." or name == ".."
			end,
			show_hidden = true,
		},
		win_options = {
			signcolumn = "yes:2",
		},
	},

	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
}
