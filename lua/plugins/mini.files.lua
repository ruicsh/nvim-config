-- File explorer.
-- https://github.com/echasnovski/mini.files

return {
	"echasnovski/mini.files",
	keys = function()
		local mf = require("mini.files")

		local function open()
			local ft = vim.bo.filetype
			if ft == "help" or ft == "fugitive" or ft == "gitcommit" or ft == "copilot-chat" then
				mf.open()
			else
				mf.open(vim.fn.expand("%:p"))
			end
		end

		local mappings = {
			{ "<leader>ee", open, "Open parent" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Files")
	end,
	opts = {
		content = {
			filter = function(entry)
				return entry.fs_type ~= "file" or entry.name ~= ".DS_Store"
			end,
		},
		mappings = {
			close = "<c-e>",
			go_in = "",
			go_in_plus = "l",
			go_out = "h",
			go_out_plus = "",
			synchronize = "<leader>w",
		},
		windows = {
			width_focus = 50,
			width_nofocus = 50,
			width_preview = 50,
		},
	},

	enabled = not vim.g.vscode,
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
}
