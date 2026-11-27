-- Directory editor
-- https://github.com/stevearc/oil.nvim

-- Helper function to parse output
local function parse_output(proc)
	local ret = {}
	if proc.code ~= 0 then
		return ret
	end
	for line in vim.gsplit(proc.stdout, "\n", { plain = true, trimempty = true }) do
		-- Remove trailing separators from directory entries
		ret[line:gsub("[/\\]+$", ""):gsub("\\", "/")] = true
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

-- Re-entering a directory re-renders it, and every fetch spawns a process.
local IGNORED_TTL = 5000

-- Shared for the empty case, since `get` runs once per listed entry
local EMPTY = {}

-- Both sides are `path -> true` maps
local function same_paths(a, b)
	for path in pairs(a) do
		if not b[path] then
			return false
		end
	end
	for path in pairs(b) do
		if not a[path] then
			return false
		end
	end
	return true
end

-- Build git-ignored file cache, keyed by repo root. The listing is relative to
-- the root, so every directory in a repo shares one `git ls-files` run.
local function new_git_status_ignored()
	local roots = {} -- dir -> repo root
	local ignored = {} -- repo root -> { at, paths } relative to that root
	local loading = {} -- repo root -> request in flight
	local again = {} -- repo root -> refetch asked for while in flight

	local function root_of(dir)
		if #dir > 1 then
			dir = dir:gsub("[/\\]+$", "")
		end
		dir = dir:gsub("\\", "/")
		local root = roots[dir]
		if not root then
			root = vim.fs.root(dir, ".git") or dir
			root = root:gsub("\\", "/")
			root = root:gsub("[/\\]+$", "")
			roots[dir] = root
		end
		return root
	end

	-- "<dir relative to root>/", or "" when dir is the root itself
	local function rel_prefix(dir, root)
		if #dir > 1 then
			dir = dir:gsub("[/\\]+$", "")
		end
		dir = dir:gsub("\\", "/")
		root = root:gsub("\\", "/"):gsub("/+$", "")
		if dir == root then
			return ""
		end
		return (dir:sub(#root + 1):gsub("^/+", "")) .. "/"
	end

	-- Load the listing in the background, then re-render oil if it changed.
	-- `force` skips the TTL after a file operation.
	local function revalidate(dir, force)
		local root = root_of(dir)
		local cached = ignored[root]
		if not force and cached and vim.uv.now() - cached.at < IGNORED_TTL then
			return
		end

		if loading[root] then
			-- The run in flight started before the write, so its result is stale
			if force then
				again[root] = true
			end
			return
		end

		loading[root] = true

		git_ignored(root, function(proc)
			loading[root] = nil
			local paths = parse_output(proc)
			local previous = cached and cached.paths
			ignored[root] = { at = vim.uv.now(), paths = paths }

			-- A reload re-scans the directory and puts the cursor back on line 1,
			-- so only pay for one when the ignored set actually changed.
			local changed
			if previous then
				changed = not same_paths(previous, paths)
			else
				changed = next(paths) ~= nil
			end

			if changed then
				vim.schedule(function()
					local bufnr = vim.api.nvim_get_current_buf()
					local current = require("oil").get_current_dir(bufnr)
					if current and root_of(current) == root and not vim.bo[bufnr].modified then
						vim.cmd.edit({ bang = true })
					end
				end)
			end

			if again[root] then
				again[root] = nil
				revalidate(dir, true)
			end
		end)
	end

	return {
		-- The first render shows ignored files and fills the cache in the
		-- background; the re-render above hides them a moment later.
		get = function(dir)
			local root = root_of(dir)
			revalidate(dir)
			local cached = ignored[root]
			return rel_prefix(dir, root), cached and cached.paths or EMPTY
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

		-- File operations change what is ignored; refetch now instead of waiting
		-- for the TTL to expire.
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "oil://*",
			callback = function(args)
				local dir = oil.get_current_dir(args.buf)
				if dir then
					git_status_ignored.revalidate(dir, true)
				end
			end,
		})

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
