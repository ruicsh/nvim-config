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
			["-"] = { "actions.parent", mode = "n" },
			["<c-l>"] = "actions.refresh",
			["<c-p>"] = "actions.preview",
			["<c-w>s"] = { "actions.select", opts = { horizontal = true } },
			["<c-w>t"] = { "actions.select", opts = { tab = true } },
			["<c-w>v"] = { "actions.select", opts = { vertical = true } },
			["<cr>"] = "actions.select",
			["_"] = { "actions.open_cwd", mode = "n" },
			["`"] = { "actions.cd", mode = "n" },
			["g."] = { "actions.toggle_hidden", mode = "n" },
			["g?"] = { "actions.show_help", mode = { "n" } },
			["g\\"] = { "actions.toggle_trash", mode = "n" },
			["gs"] = { "actions.change_sort", mode = "n" },
			["gx"] = "actions.open_external",
			["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
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
	enabled = not vim.g.vscode,
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
}
