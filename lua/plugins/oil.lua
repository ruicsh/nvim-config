-- Directory editor
-- https://github.com/stevearc/oil.nvim

-- Helper function to parse output
local function parse_output(proc)
	local ret = {}
	if proc.code ~= 0 then
		return ret
	end
	for line in vim.gsplit(proc.stdout, "\n", { plain = true, trimempty = true }) do
		-- Remove trailing slash
		ret[line:gsub("/$", "")] = true
	end
	return ret
end

local GIT_IGNORED_ARGS = { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" }

local function git_ignored(cwd, on_exit)
	return vim.system(GIT_IGNORED_ARGS, {
		cwd = cwd,
		text = true,
		-- Read-only: don't refresh or lock the index
		env = { GIT_OPTIONAL_LOCKS = "0" },
	}, on_exit)
end

-- Build git-ignored file cache, keyed by repo root. The listing is relative to
-- the root, so every directory in a repo shares one `git ls-files` run.
local function new_git_status_ignored()
	local roots = {} -- dir -> repo root
	local ignored = {} -- repo root -> ignored paths, relative to that root

	local function root_of(dir)
		if #dir > 1 then
			dir = dir:gsub("/+$", "")
		end
		local root = roots[dir]
		if not root then
			root = vim.fs.root(dir, ".git") or dir
			roots[dir] = root
		end
		return root
	end

	-- "<dir relative to root>/", or "" when dir is the root itself
	local function rel_prefix(dir, root)
		if #dir > 1 then
			dir = dir:gsub("/+$", "")
		end
		if dir == root then
			return ""
		end
		return (dir:sub(#root + 1):gsub("^/+", "")) .. "/"
	end

	-- Reload a stale listing without blocking, then re-render oil if it shows it
	local function revalidate(root)
		git_ignored(root, function(proc)
			ignored[root] = parse_output(proc)
			vim.schedule(function()
				local bufnr = vim.api.nvim_get_current_buf()
				local dir = require("oil").get_current_dir(bufnr)
				if dir and root_of(dir) == root and not vim.bo[bufnr].modified then
					vim.cmd.edit({ bang = true })
				end
			end)
		end)
	end

	return {
		-- oil filters entries while rendering, so the first listing blocks
		get = function(dir)
			local root = root_of(dir)
			local paths = ignored[root]
			if not paths then
				paths = parse_output(git_ignored(root):wait(2000))
				ignored[root] = paths
			end
			return rel_prefix(dir, root), paths
		end,
		revalidate = revalidate,
	}
end

return {
	"stevearc/oil.nvim",
	keys = {
		{ "-", "<cmd>Oil<cr>", desc = "Oil: Open dir" },
		{
			"_",
			function()
				require("oil").open(vim.fn.getcwd())
			end,
			desc = "Oil: Open cwd",
		},
	},

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
			["<bs>"] = "actions.parent",
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

		-- Re-read ignored files in the background on refresh; the current listing
		-- stays valid until the new one arrives.
		local refresh = actions.refresh
		local orig_refresh = refresh.callback
		refresh.callback = function(...)
			local dir = oil.get_current_dir(vim.api.nvim_get_current_buf())
			if dir then
				git_status_ignored.revalidate(dir)
			end
			orig_refresh(...)
		end

		-- Show git-ignored files as hidden
		opts.view_options.is_hidden_file = function(name, bufnr)
			local dir = oil.get_current_dir(bufnr)
			if not dir then
				return false
			end
			local rel, paths = git_status_ignored.get(dir)
			return paths[rel .. name] or false
		end

		oil.setup(opts)
	end,

	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
}
