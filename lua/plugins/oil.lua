-- Directory editor
-- https://github.com/stevearc/oil.nvim

-- Helper function to parse output
local function parse_output(proc)
	local result = proc:wait()
	local ret = {}
	if result.code == 0 then
		for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
			-- Remove trailing slash
			line = line:gsub("/$", "")
			ret[line] = true
		end
	end
	return ret
end

-- Build git status cache
local function new_git_status_ignored()
	return setmetatable({}, {
		__index = function(self, key)
			local ignore_proc = vim.system(
				{ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
				{ cwd = key, text = true }
			)
			local ret = parse_output(ignore_proc)
			rawset(self, key, ret)
			return ret
		end,
	})
end

return {
	"stevearc/oil.nvim",
	keys = function()
		local oil = require("oil")

		local function open_cwd()
			oil.open(vim.fn.getcwd())
		end

		return {
			{ "-", "<cmd>Oil<cr>", desc = "Oil: Open parent" },
			{ "_", open_cwd, desc = "Oil: Open cwd" },
		}
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
			["<tab>"] = "actions.preview",
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
	config = function(_, opts)
		local oil = require("oil")
		local actions = require("oil.actions")

		local git_status_ignored = new_git_status_ignored()

		-- Clear git status cache on refresh
		local refresh = actions.refresh
		local orig_refresh = refresh.callback
		refresh.callback = function(...)
			git_status_ignored = new_git_status_ignored()
			orig_refresh(...)
		end

		-- Show git-ignored files as hidden
		opts.view_options.is_hidden_file = function(name, bufnr)
			local dir = oil.get_current_dir(bufnr)
			return git_status_ignored[dir][name]
		end

		oil.setup(opts)
	end,

	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
}
