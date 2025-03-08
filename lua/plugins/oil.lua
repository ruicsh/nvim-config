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
		delete_to_trash = true,
		keymaps = {
			["<cr>"] = "actions.select",
			["<c-s>"] = { "actions.select", opts = { horizontal = true } },
			["<c-v>"] = { "actions.select", opts = { vertical = true } },
			["-"] = { "actions.parent", mode = { "n" } },
		},
		skip_confirm_for_simple_edits = true,
		view_options = {
			is_always_hidden = function(name, _)
				return name == "." or name == ".."
			end,
			show_hidden = true,
		},
	},

	cmd = "Oil",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
}
