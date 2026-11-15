local M = {}

M.default_branch = function()
	-- Use `git symbolic-ref` to directly get the default branch name
	local args = { "git", "symbolic-ref", "refs/remotes/origin/HEAD" }

	local result = vim.system(args):wait(5000)
	if not result or result.code ~= 0 or not result.stdout then
		return nil, "Could not find HEAD branch"
	end

	-- Remove trailing newline
	local branch = result.stdout:gsub("%s+$", "")
	if branch == "" then
		return nil, "Could not find HEAD branch"
	end
	return branch
end

-- Remote-tracking branches, newest first. Reads local refs; no network.
---@return string[]
M.remote_branches = function()
	local result = vim.system({
		"git",
		"for-each-ref",
		"--format=%(refname)",
		"--sort=-committerdate",
		"refs/remotes",
	}, { text = true }):wait(5000)

	if not result or result.code ~= 0 or not result.stdout then
		return {}
	end

	local branches = {}
	for line in vim.gsplit(result.stdout, "\n", { trimempty = true }) do
		if not line:match("/HEAD$") then
			branches[#branches + 1] = line:gsub("^refs/remotes/", "")
		end
	end
	return branches
end

-- Commit where `ref` and the current HEAD diverged, or nil. Diffing against
-- this commit includes uncommitted work, unlike `<ref>...` which stops at HEAD.
---@param ref string
---@return string?
M.merge_base = function(ref)
	local result = vim.system({ "git", "merge-base", ref, "HEAD" }, { text = true }):wait(5000)
	if not result or result.code ~= 0 or not result.stdout then
		return nil
	end

	local sha = result.stdout:gsub("%s+$", "")
	if sha == "" then
		return nil
	end
	return sha
end

--- Pick the base to review against: the default branch first, then remote
--- branches newest-first. Calls `cb` with the chosen ref and the commit where
--- it diverged from HEAD.
---@param cb fun(base: string, merge_base: string)
M.pick_review_base = function(cb)
	local default = M.default_branch()
	if default then
		default = default:gsub("^refs/remotes/", "")
	end

	local items, seen = {}, {}
	if default then
		items[#items + 1] = { branch = default, is_default = true }
		seen[default] = true
	end
	for _, branch in ipairs(M.remote_branches()) do
		if not seen[branch] then
			seen[branch] = true
			items[#items + 1] = { branch = branch }
		end
	end

	if #items == 0 then
		vim.notify("Could not determine the base branch", vim.log.levels.WARN)
		return
	end

	vim.ui.select(items, {
		prompt = "Review base:",
		format_item = function(item)
			return item.is_default and (item.branch .. " (default)") or item.branch
		end,
	}, function(item)
		if not item then
			return
		end

		local merge_base = M.merge_base(item.branch)
		if not merge_base then
			vim.notify(("Could not find merge-base with %s"):format(item.branch), vim.log.levels.WARN)
			return
		end
		cb(item.branch, merge_base)
	end)
end

M.diff = function(ref)
	-- To ignore files (ex. package-lock.json) add 'package-lock.json -diff' to .gitattributes
	local args = { "git", "diff", "--no-color", ref }

	local result = vim.system(args):wait(10000)
	if not result or not result.stdout then
		return nil, "Could not get git diff"
	end

	return result.stdout
end

M.blame_line = function()
	local linenr = vim.fn.line(".")
	local file = vim.fn.expand("%")
	local args = { "git", "blame", "-L", linenr .. ",+1", file }

	local result = vim.system(args):wait(5000)
	if not result or not result.stdout then
		return nil, "Could not get blame info"
	end

	return result.stdout
end

-- Returns the hash of the commit that last touched `linenr`, or nil when the
-- line is uncommitted, the file is untracked, or not inside a git repository.
M.commit_at_line = function(linenr)
	linenr = linenr or vim.fn.line(".")
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		return nil
	end

	local args = {
		"git",
		"-C",
		vim.fn.fnamemodify(file, ":h"),
		"blame",
		"-L",
		("%d,%d"):format(linenr, linenr),
		"--porcelain",
		"--",
		file,
	}

	local result = vim.system(args):wait(5000)
	if not result or result.code ~= 0 or not result.stdout then
		return nil
	end

	-- All-zero hash means the line is not committed yet
	local hash = result.stdout:match("^(%x%x%x%x%x%x%x+)")
	if not hash or hash:match("^0+$") then
		return nil
	end

	return hash
end

M.repo_status = function(callback, cwd)
	cwd = cwd or vim.fn.getcwd()

	vim.system({ "git", "status", "--porcelain" }, { cwd = cwd }, function(result)
		if result.code ~= 0 or not result.stdout then
			callback("")
			return
		end

		local added, modified, deleted, untracked = 0, 0, 0, 0
		local code_map = { A = "added", C = "added", M = "modified", D = "deleted", R = "modified" }

		for line in vim.gsplit(result.stdout, "\n", { trimempty = true }) do
			if line:sub(1, 2) == "??" then
				untracked = untracked + 1
			elseif line:sub(1, 2) ~= "!!" then
				for _, ch in ipairs({ line:sub(1, 1), line:sub(2, 2) }) do
					local cat = code_map[ch]
					if cat == "added" then
						added = added + 1
					elseif cat == "modified" then
						modified = modified + 1
					elseif cat == "deleted" then
						deleted = deleted + 1
					end
				end
			end
		end

		local parts = {}
		if added > 0 then
			table.insert(parts, string.format("+%d", added))
		end
		if modified > 0 then
			table.insert(parts, string.format("~%d", modified))
		end
		if deleted > 0 then
			table.insert(parts, string.format("-%d", deleted))
		end
		if untracked > 0 then
			table.insert(parts, string.format("?%d", untracked))
		end

		callback(table.concat(parts, " "))
	end)
end

M.is_rebasing = function()
	local merge = vim.system({ "git", "rev-parse", "--git-path", "rebase-merge" }):wait(5000)
	if merge and merge.stdout then
		local result = merge.stdout:gsub("%s+$", "")
		if result ~= "" and vim.uv.fs_stat(result) then
			return true
		end
	end

	local apply = vim.system({ "git", "rev-parse", "--git-path", "rebase-apply" }):wait(5000)
	if apply and apply.stdout then
		local result = apply.stdout:gsub("%s+$", "")
		if result ~= "" and vim.uv.fs_stat(result) then
			return true
		end
	end

	return false
end

M.remote_status = function(callback, cwd)
	cwd = cwd or vim.fn.getcwd()

	vim.system({ "git", "rev-parse", "--abbrev-ref", "@{upstream}" }, { cwd = cwd }, function(u_result)
		if u_result.code ~= 0 then
			callback("")
			return
		end

		local upstream = u_result.stdout:gsub("%s+$", "")
		if upstream == "" then
			callback("")
			return
		end

		vim.system(
			{ "git", "rev-list", "--left-right", "--count", "@{upstream}...HEAD" },
			{ cwd = cwd },
			function(c_result)
				if c_result.code ~= 0 then
					callback("")
					return
				end

				local behind, ahead = c_result.stdout:match("^(%d+)%s+(%d+)")
				ahead = tonumber(ahead) or 0
				behind = tonumber(behind) or 0

				if ahead == 0 and behind == 0 then
					callback("")
					return
				end

				local parts = {}
				if ahead > 0 then
					table.insert(parts, string.format("↑%d", ahead))
				end
				if behind > 0 then
					table.insert(parts, string.format("↓%d", behind))
				end

				callback(table.concat(parts))
			end
		)
	end)
end

return M
