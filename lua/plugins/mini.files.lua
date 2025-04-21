-- File explorer.
-- https://github.com/echasnovski/mini.files

return {
	"echasnovski/mini.files",
	keys = function()
		local mf = require("mini.files")

		local function open()
			local ft = vim.bo.filetype

			-- Already open, do nothing
			if ft == "minifiles" then
				return
			end

			-- Don't open current directory on these special buffers
			if ft == "help" or ft == "fugitive" or ft == "gitcommit" or ft == "copilot-chat" then
				mf.open()
			else
				mf.open(vim.fn.expand("%:p"))
			end
		end

		local function open_cwd()
			mf.open(vim.fn.getcwd())
		end

		local mappings = {
			{ "-", open, "Open parent dir" },
			{ "_", open_cwd, "Open cwd" },
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
			go_in_plus = "<cr>",
			go_out = "",
			go_out_plus = "-",
			synchronize = "<c-s>",
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
